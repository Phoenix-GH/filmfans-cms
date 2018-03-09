class Json::MediaContentsController < ApplicationController
  def create
    @form = Panel::CreateMediaContentForm.new(media_content_form_params)
    service = Panel::CreateMediaContentService.new(form: @form)

    if service.call
      json = {
        media_content_id: service.media_content.id,
        thumb_url: service.media_content.cover_image.small_thumb.url
      }
      render json: json, status: :ok
    else
      render json: @form.errors.full_messages, status: :unprocessable_entity
    end
  end

  def destroy
    @media_content = MediaContent.find(params[:id])
    service = Panel::DestroyMediaContentService.new(@media_content)

    if service.call
      render json: { message: :success }, status: :ok
    else
      render json: { message: :error }, status: :unprocessable_entity
    end
  end

  private
  def media_content_form_params
    params.permit(:cover_image, :file)
  end
end
