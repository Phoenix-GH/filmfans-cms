class Json::ProductFilesController < ApplicationController
  def create
    @form = Panel::CreateProductFileForm.new(product_file_form_params)
    service = Panel::CreateProductFileService.new(form: @form)

    if service.call
      json = {
        product_file_id: service.product_file.id,
        thumb_url: service.product_file.cover_image.small_thumb.url
      }
      render json: json, status: :ok
    else
      render json: @form.errors.full_messages, status: :unprocessable_entity
    end
  end

  def destroy
    @product_file = ProductFile.find(params[:id])
    service = Panel::DestroyProductFileService.new(@product_file)

    if service.call
      render json: { message: :success }, status: :ok
    else
      render json: { message: :error }, status: :unprocessable_entity
    end
  end

  private
  def product_file_form_params
    params.permit(:cover_image, :file)
  end
end
