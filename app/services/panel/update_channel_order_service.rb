class Panel::UpdateChannelOrderService
  def initialize(channel_ids_str)
    @ids = channel_ids_str&.split(",")
  end

  def call
    return true if @ids&.blank?

    ActiveRecord::Base.transaction do
      update_channel
    end
  end

  private

  def update_channel
    @ids = @ids.map { |str| str.to_i }

    id_2_channel = {}
    Channel.find(@ids).each { |ch|
      id_2_channel[ch.id] = ch
    }

    ## we will order DESC. That allow us to easily put the newly created channel to the top
    @ids.each_with_index { |ch_id, index|
      id_2_channel[ch_id].position = @ids.size - index
      id_2_channel[ch_id].save
    }
    true
  end
end
