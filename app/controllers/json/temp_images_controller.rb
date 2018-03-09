class Json::TempImagesController < ApplicationController
  def create
    @form = Panel::CreateTempImageForm.new(temp_image_form_params)
    service = Panel::CreateTempImageService.new(form: @form)

    if service.call
      json = {
        temp_image_id: service.temp_image.id,
        thumb_url: service.temp_image.image.small_thumb.url
      }
      render json: json, status: :ok
    else
      render json: @form.errors.full_messages, status: :unprocessable_entity
    end
  end

  def destroy
    @temp_image = TempImage.find(params[:id])
    service = Panel::DestroyTempImageService.new(@temp_image)

    if service.call
      render json: { message: :success }, status: :ok
    else
      render json: { message: :error }, status: :unprocessable_entity
    end
  end

  private
  def temp_image_form_params
    params.permit(:image)
  end
end
