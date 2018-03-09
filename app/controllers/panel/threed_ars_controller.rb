require 'rest-client'

class Panel::ThreedArsController < Panel::BaseController
  before_action :set_threed_ar, only: [:edit, :update, :destroy]

  def index
    @threed_ars = ThreedArQuery.new(threed_ar_search_params).results
  end

  def new
    @form = Panel::CreateThreedArForm.new
  end

  def create
    @form = Panel::CreateThreedArForm.new(threed_ar_form_params)
    service = Panel::CreateThreedArService.new(@form)

    @threed_ar = service.call
    if @threed_ar
      message = 'The 3D/AR was successfully created.'
      unless save_wikitube_collection
        message = 'The 3D/AR was created but failed to create corresponding on Wikitube.'
      end

      redirect_to panel_threed_ar_threed_models_path(@threed_ar),
                  notice: _(message)
    else
      render :new
    end
  end

  def edit
    @form = Panel::UpdateThreedArForm.new(threed_ar_params, {})
  end

  def update
    @form = Panel::UpdateThreedArForm.new(threed_ar_params, threed_ar_form_params)

    service = Panel::UpdateThreedArService.new(@threed_ar, @form)

    if service.call
      message = 'The 3D/AR was successfully updated.'

      if delete_wikitube_collection
        @threed_ar.ar_collection_id = nil
        @threed_ar.save

        if save_wikitube_collection
          message = 'The 3D/AR was successfully updated.'
        else
          message = 'The 3D/AR was updated but failed to update corresponding on Wikitube.'
        end
      else
        message = 'The 3D/AR was updated but failed to update corresponding on Wikitube.'
      end

      redirect_to panel_threed_ar_threed_models_path(@threed_ar),
                  notice: _(message)
    else
      render :edit
    end
  end

  def destroy
    @threed_ar.destroy
    delete_wikitube_collection

    redirect_to panel_threed_ars_path, notice: _('The 3D/AR was successfully deleted.')
  end

  private

  def save_wikitube_collection
    target_id_path = ''
    unless @threed_ar.ar_collection_id.blank?
      target_id_path = "/#{@threed_ar.ar_collection_id}"
    end

    RestClient.post("#{ENV['WIKITUBE_HOST']}/cloudrecognition/targetCollection/#{ENV['WIKITUBE_TARGET_COLLECTION_ID']}/target#{target_id_path}",
                    {
                        :name => "filmfans-collection-#{@threed_ar.id} - #{@threed_ar.name}",
                        :imageUrl => @threed_ar.trigger_image_url,
                        :metadata => {
                            :resource_id => @threed_ar.id
                        }
                    }.to_json,
                    wikitube_create_target_header) { |response, request, result, &block|
      case response.code
        when 200
          json_result = JSON.parse(response.body)
          @threed_ar.ar_collection_id = json_result["id"]
          @threed_ar.save

          # refresh the correct to have it take effect
          RestClient.post "#{ENV['WIKITUBE_HOST']}/cloudrecognition/targetCollection/#{ENV['WIKITUBE_TARGET_COLLECTION_ID']}/generation",
                          {}.to_json, wikitube_create_target_header
        else
          Rails.logger.error response
          return false
      end
    }
    true
  end

  def delete_wikitube_collection
    unless @threed_ar.ar_collection_id.blank?
      RestClient.delete("#{ENV['WIKITUBE_HOST']}/cloudrecognition/targetCollection/#{ENV['WIKITUBE_TARGET_COLLECTION_ID']}/target/#{@threed_ar.ar_collection_id}", wikitube_delete_target_header) { |response, request, result, &block|
        case response.code
          when 204
            Rails.logger.info response
          else
            Rails.logger.error response
            return false
        end
      }
    end
    true
  end

  def wikitube_create_target_header
    {
        :'Content-Type' => 'application/json',
        :'X-Token' => ENV['WIKITUDE_API_TOKEN_FOR_CMS'],
        :'X-Version' => ENV['WIKITUDE_VERSION']
    }
  end

  def wikitube_delete_target_header
    {
        :'X-Token' => ENV['WIKITUDE_API_TOKEN_FOR_CMS'],
        :'X-Version' => ENV['WIKITUDE_VERSION']
    }
  end

  def set_threed_ar
    @threed_ar = ThreedAr.find(params[:id])
  end

  def sort_column
    ['name']
  end

  def threed_ar_params
    @threed_ar.slice(:name, :message, :image)
  end

  def threed_ar_search_params
    params.permit(:search, :page, :per)
  end


  def threed_ar_form_params
    params.require(:threed_ar_form).permit(:name, :message, :image)
  end

end
