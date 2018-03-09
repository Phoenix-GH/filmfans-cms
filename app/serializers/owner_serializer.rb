class OwnerSerializer
  def initialize(source_owner)
    @source_owner = source_owner
  end

  def results
    return {} unless @source_owner
    generate_source_owner_json

    @source_owner_json
  end

  private
  def generate_source_owner_json
    @source_owner_json = {
      id: @source_owner.id,
      type: @source_owner.class.name.underscore,
      name: @source_owner.name,
      thumbnail_url: @source_owner.picture.present? ? @source_owner.picture.custom_url : ''
    }
  end
end
