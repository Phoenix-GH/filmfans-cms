class MagazineImagePageCrawlerJob < ActiveJob::Base
  # A big page would take 3 minutes to convert to image
  PAGE_404_RETRY_TIMEOUT_IN_SECOND = 10
  PAGE_404_RETRY_MAX_SECOND = 4*60

  queue_as :default

  def self.crawl_if_needed(issue_id)
    issue = Issue.find(issue_id)
    unless issue.missing_page_images.empty?
      MagazineImagePageCrawlerJob.perform_later(issue_id)
    else
      Sidekiq.logger.info "Issue #{issue_id}: No missing image to crawl"
    end
  end

  # Sidekiq will retry failures with an exponential backoff using the formula
  # (retry_count ** 4) + 15 + (rand(30) * (retry_count + 1))
  # (i.e. 15, 16, 31, 96, 271, ... seconds + a random amount of time).
  # It will perform 25 retries over approximately 21 days
  # https://github.com/mperham/sidekiq/wiki/Error-Handling

  # IMPORTANT: when modifying this class, keep in mind that multiple instances can run on the same issue_id.
  #           The implementation must support this.
  def perform(issue_id)
    issue = Issue.find(issue_id)

    @issue_id = issue_id
    @base_page_url_ulab_api = issue.pdf_image_base_url
    @total_page_ulab_api = issue.pdf_pages
    return unless @base_page_url_ulab_api.to_s != '' and !@total_page_ulab_api.nil?

    generate_issue_pages issue_id
  end

  private

  def generate_issue_pages(issue_id)
    @pending_404_pages = []
    @crawl_count = 0

    (1..@total_page_ulab_api).each do |page_number|
      # fetch the fresh new info from DB
      existing_page = IssuePage.find_by(issue_id: issue_id, page_number: page_number)
      issue_page = determine_page_to_crawl(existing_page, page_number)

      unless issue_page.nil?
        crawl_page(page_number, issue_page)
      end
    end

    Sidekiq.logger.info "#{@crawl_count} new images were crawled for issue #{@issue_id}"

    if @pending_404_pages.size > 0
      raise "Issue #{@issue_id} has #{@pending_404_pages.size} pages with 404 error. Job will be put in the retry queue " +
                "and will be retried by sidekiq. Pages: #{@pending_404_pages}"
    end
  end

  def determine_page_to_crawl(existing_page, page_number)
    issue_page = nil
    if existing_page.present?
      unless existing_page.image&.file&.exists?
        issue_page = existing_page
        issue_page.page_number = page_number
      end
    else
      issue_page = IssuePage.new(
          {
              issue_id: @issue_id,
              description: "P.#{page_number}",
              page_number: page_number
          })
    end
    issue_page
  end

  def crawl_page(page_number, issue_page)
    image_url_to_crawl = @base_page_url_ulab_api + "-#{page_number - 1}.png"
    Sidekiq.logger.info ">>>issue ID(#{issue_page.issue_id}): about to crawl image: #{image_url_to_crawl}"

    # crawl the remote image and create pages with thumbnails
    issue_page.remote_image_url = image_url_to_crawl

    retry_duration = -1 * PAGE_404_RETRY_TIMEOUT_IN_SECOND
    begin
      retry_duration += PAGE_404_RETRY_TIMEOUT_IN_SECOND
      issue_page.save!
      @crawl_count += 1
      Sidekiq.logger.info "<<<issue ID(#{issue_page.issue_id}): crawled image: #{image_url_to_crawl}"

      # update the cover image
      # if the cover image has already existed, we don't touch that as that can be the high-quality image
      # that the users want and they may do some cropping on it
      if page_number == 1
        issue = Issue.find(issue_page.issue_id)
        unless issue.cover_image.file.present?
          issue.cover_image.remote_file_url = image_url_to_crawl
          issue.save
        end
      end

    rescue ActiveRecord::RecordNotUnique => e
      Sidekiq.logger.warn "Page #{page_number}, issue #{issue_page.issue_id} has already existed. " +
                              "Another job may insert it in the meantime"

    rescue ActiveRecord::RecordInvalid => e
      if e.message.include?('404 Not Found')
        Sidekiq.logger.warn "Page #{page_number}, issue #{issue_page.issue_id} not found, " +
                                "maybe it is being generated: #{image_url_to_crawl}"

        if retry_duration < PAGE_404_RETRY_MAX_SECOND
          Sidekiq.logger.warn "Page #{page_number}, issue #{issue_page.issue_id}, " +
                                  "retry to crawl in #{PAGE_404_RETRY_TIMEOUT_IN_SECOND} seconds"
          # return the "begin" block
          sleep(PAGE_404_RETRY_TIMEOUT_IN_SECOND)
          retry
        else
          # move on to the next page. We will raise an error after scanning through out all pages so that sidekiq will
          # retry for us
          @pending_404_pages << page_number
        end
      else
        raise
      end
    end
  end

end