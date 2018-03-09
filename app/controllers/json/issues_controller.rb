class Json::IssuesController < ApplicationController
  before_action :set_issue, :except => [:compress_images]

  def on_pdf_uploaded
    form = Panel::SaveIssueUploadedPdfForm.new(pdf_uploaded_params)
    service = Panel::UpdateIssuePdfService.new(@issue, form)

    if service.call
      if Sidekiq::ProcessSet.new.size == 0
        logger.error "Sidekiq is not started. If you are in development, please start it with command: bundle exec sidekiq"

        render json: {
            error: 'Your file has been uploaded successfully. ' +
                'Every page needs to be converted into images so that you can continue working on. ' +
                'However, the background job doing that task is not running. ' +
                "Please contact the system administrator (and you don't have to re-upload this file)." +
                'For the system administrator: please make sure sidekiq is started and working properly'
        }
      else
        render json: images_json(false, false)
      end
    else
      render json: {
          error: @form.errors.full_messages
      }
    end
  end

  def load_images
    only_with_tags = load_images_params[:only_with_tags] || 'false'
    only_visible = load_images_params[:only_visible] || 'false'
    json = images_json(only_with_tags == 'true', only_visible == 'true')
    if load_images_params[:include_tag_categories]
      json = json.merge(
          {
              tag_categories: all_categories_json
          })
    end
    render json: json
  end

  def save_tags
    issue_page = IssuePage.find(save_tags_params[:page_id])
    # expected json
    # {
    #     page_id: 0,
    #     tags: [
    #         {
    #             tag_id: 0,
    #             product_ids: [0, 1, 2],
    #             specification: {
    #                 orig_width: 0,
    #                 orig_height: 1,
    #                 x: 0,
    #                 y: 0,
    #                 type: 'xxx'
    #             }
    #         }
    #     ]
    # }

    Panel::UpdateIssuePageTagsService.new(issue_page, save_tags_params['tags']).update_tags
    issue_page.reload

    render json: serialize_one_page(issue_page)
  end

  def load_all_categories
    render json: all_categories_json
  end

  def set_visible
    page_id = set_visible_params[:page_id]
    issue_page = IssuePage.find(page_id)
    raise "Page ID #{page_id} does not belong to issue #{@issue.id}" unless issue_page.issue.id == @issue.id
    issue_page.visible = set_visible_params[:visible]
    issue_page.save!
    render json: {}
  end

  def compress_images
    MagazineImagePageCompressorJob.perform_later(params[:issue_id])
    render json: {
        message: 'Task submitted, check sidekiq for progress'
    }
  end

  private

  def all_categories_json
    IssueTagCategories::all.map do |category|
      {
          type: category[:type],
          label: category[:label],
          url: IssueTagCategories::icon_url(category[:type])
      }
    end
  end

  def images_json(only_having_tags, only_visible)
    {
        issue_id: @issue.id,
        # pdf_file = null: no pdf uploaded yet
        pdf_file: serialize_pdf_info,
        images: serialize_images(only_having_tags, only_visible)
    }
  end


  def serialize_pdf_info
    return unless @issue.pdf_url.present?
    {
        # missing_images == 0: all images were crawled
        # missing_images > 0: crawling in-progress
        total_pages: @issue.pdf_pages || 0,
        missing_images: @issue.missing_page_images.size
    }
  end

  def serialize_images(only_having_tags, only_visible)
    pages = @issue.issue_pages.includes(:issue_page_tags)

    pages = pages&.reject do |page|
      (only_visible and !page.visible) ||
          (only_having_tags and page&.issue_page_tags.empty?)
    end

    pages&.map do |page|
      serialize_one_page page
    end
  end

  def serialize_one_page(page)
    {
        id: page.id,
        description: page.description,
        url_thumbnail: page.thumbnail_url,
        url_full: page.full_size_url,
        tags: serialize_tags(page),
        visible: page.visible
    }
  end

  def serialize_tags(issue_page)
    issue_page.issue_page_tags&.map do |tag|
      products_json = serialize_products(tag.issue_tag_products)
      {
          id: tag.id,
          specification: tag.specification,
          products: products_json,
          product_ids: products_json.map { |p| p[:id] }
      }
    end
  end

  def serialize_products(issue_tag_products)
    issue_tag_products.map { |issue_tag_product|
      Json::ProductsController::serialize_one_product issue_tag_product.product
    }
  end

  def set_issue
    @issue = Issue.find(params[:id])
  end

  def pdf_uploaded_params
    params.permit(:pdf_user_file_name, :pdf_file_name, :pdf_url, :image_url_prefix, :total_pages)
  end

  def load_images_params
    params.permit(:only_with_tags, :include_tag_categories, :only_visible)
  end

  def save_tags_params
    params.permit(:page_id, {tags: [:tag_id, product_ids: [], specification: [:orig_width, :orig_height, :x, :y, :type, :orientation]]})
  end

  def set_visible_params
    params.permit(:page_id, :visible)
  end

end