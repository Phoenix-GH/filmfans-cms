class Panel::UpdateIssuePdfService
  def initialize(issue, form)
    @issue = issue
    @form = form
  end

  def call
    return false unless @form.valid?

    ActiveRecord::Base.transaction do
      @issue.pdf_file_name = @form.pdf_user_file_name
      @issue.pdf_url = @form.pdf_url
      @issue.pdf_pages = @form.total_pages
      prefix = @form.image_url_prefix
      prefix = prefix + '/' unless prefix.end_with? '/'
      @issue.pdf_image_base_url = prefix + @form.pdf_file_name
      @issue.save!

      # don't know why @issue.issue_pages.clear doesn't work. It's supposed to use the 'dependent: :destroy' strategy
      # if it doesn't
      @issue.issue_pages.destroy(@issue.issue_pages)
    end

    MagazineImagePageCrawlerJob.crawl_if_needed(@issue.id)

    @issue
  end
end