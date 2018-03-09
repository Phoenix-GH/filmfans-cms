class ThreedArSerializer
  def initialize(threed_ar)
    @threed_ar = threed_ar
  end

  def results
    return '' unless @threed_ar
    generate_threed_ar_json

    @threed_ar_json
  end

  private
  def generate_threed_ar_json
    @threed_ar_json = {
      id: @threed_ar.id,
      name: @threed_ar.name.to_s,
      message: @threed_ar.message.to_s,
      trigger_image_url: @threed_ar.trigger_image_url.to_s,
      threed_models: threed_models
    }
  end

  def threed_models
    return [] if @threed_ar.threed_models.blank?

    @threed_ar.threed_models.map do |threed_model|
      ThreedModelSerializer.new(threed_model).results if threed_model.present?
    end
  end

end
