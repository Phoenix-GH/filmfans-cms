class Panel::UpdatePositionService
  def initialize(source, ids_str, options = {})
    @source = source
    @ids = ids_str&.split(",")
    @options = options
  end

  def call
    return true if @ids&.blank?

    ActiveRecord::Base.transaction do
      if @options[:page]
        update_order_pages
      else
        update_order
      end
    end
  end

  private

  def update_order
    @ids = @ids.map { |str| str.to_i }

    item_ids = {}
    @source.find(@ids).each { |item|
      item_ids[item.id] = item
    }

    ## we will order DESC. That allow us to easily put the newly created item to the top
    @ids.each_with_index { |id, index|
      item_ids[id].position = @ids.size - index
      item_ids[id].save
    }
    true
  end

  def update_order_pages
    return false if @options[:page].nil?
    per = (@options[:per] || 25).to_i
    page = @options[:page]
    items_count = @source.count
    iposition = 1
    # page_count = (items_count * 1.0 / per).ceil

    @ids = @ids.map { |str| str.to_i }
    ids_h = @ids.map.with_index { |id, idx| [id, idx] }.to_h

    @source.order(position: :asc).all.each { |item|
      current_page = (iposition * 1.0 / per).ceil
      target_idx = ids_h[item.id]
      if target_idx
        item.position = (current_page - 1) * per + target_idx + 1
      else
        item.position = iposition
      end
      item.save
      iposition += 1
    }

    true
  end


  def remained_count(total_count, page, per)
    pos = (page - 1) * per
    total_count - pos
  end
end
