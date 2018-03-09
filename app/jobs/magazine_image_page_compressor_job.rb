class MagazineImagePageCompressorJob < ActiveJob::Base

  queue_as :default

  def perform(issue_id)
    issue_ids = []
    if issue_id.blank?
      issue_ids = list_issue_ids_having_pdf
    else
      issue_ids << issue_id.to_i
    end

    issue_ids.each { |id| compress_for_issue(id) }
  end

  private

  def list_issue_ids_having_pdf
    Issue.where.not(pdf_image_base_url: nil).pluck(:id)
  end

  def compress_for_issue(issue_id)
    issue_page_ids = IssuePage.where(issue_id: issue_id).where.not(image: nil).pluck(:id)

    issue_page_ids.each { |id| compress_one_page(id) }
  end

  def compress_one_page(page_id)
    # return nil if not found
    page = IssuePage.find_by id: page_id
    return unless page.present?

    unless page.thumbnail_image_exists?
      recreate_version(page, :thumbnail)
    end
    unless page.quality_100_image_exists?
      recreate_version(page, :quality_100)
    end
    unless page.quality_95_image_exists?
      recreate_version(page, :quality_95)
    end
    unless page.quality_85_image_exists?
      recreate_version(page, :quality_85)
    end
  end

  def recreate_version(page, version)
    Sidekiq.logger.info "Compressing image for page ID #{page.id}, version #{version}"

    # https://github.com/carrierwaveuploader/carrierwave/wiki/How-to:-Recreate-and-reprocess-your-files-stored-on-fog
    page.image.cache_stored_file!
    page.image.retrieve_from_cache!(page.image.cache_name)
    page.image.recreate_versions!(version)
    page.save!
  end

end