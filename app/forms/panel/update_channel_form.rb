class Panel::UpdateChannelForm < Panel::BaseChannelForm

  def initialize(channel_attrs, form_attributes = {})
    super channel_attrs.merge(form_attributes)
  end

end
