module ApplicationHelper
  def sortable(column, title = nil)
    title ||= column.titleize
    css_class = column == sort_column ? "sortable current #{sort_direction}" : 'sortable'
    direction = column == sort_column && sort_direction == 'asc' ? 'desc' : 'asc'
    filters = {sort: column, direction: direction}

    unless params.blank?
      clean_params = params.except(:sort, :direction, :controller, :action)
      filters.merge!(clean_params)
    end

    link_to title, filters, {class: css_class}
  end

  def tags_array(object)
    object.tags.map do |tag|
      {
          x: tag.coordinate_x,
          y: tag.coordinate_y,
          text: tag.product.name
      }
    end
  end

  def similar_option_from_token(id)
    object = Product.find(id)
    {
        name: object&.name,
        id: id,
        image: object.product_files.first&.thumb_cover_image_url
    }
  end

  def collections_option_from_token(id)
    object = Collection.find(id)
    {
        name: object&.name,
        id: id
    }
  end

  def link_to_remove_fields(name, f, target_container: nil, &block)
    if block.present?
      f.hidden_field(:_destroy) + link_to("javascript:void(0);", class: "remove_link", data: {target_container: target_container}, &block)
    else
      f.hidden_field(:_destroy) + link_to(name, "javascript:void(0);", class: "remove_link", data: {target_container: target_container})
    end
  end

  def link_to_add_fields(name, f, association)
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, new_object, child_index: "new_#{association}") do |builder|
      render('panel/collections/' + association.to_s.singularize + "_fields", f: builder)
    end
    link_to(name, "javascript:void(0);", class: "add_link btn btn-gray btn-add", data: {association: association, content: fields.gsub("\n", "")})
  end

  def link_to_add_association_fields(name, f, association, render_template, btn_class: 'btn btn-gray', target_container: nil)
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, new_object, child_index: "new_#{association}") do |builder|
      render(render_template, f: builder)
    end
    link_to(name, "javascript:void(0);", class: "add_link btn-add #{btn_class}", data: {association: association, content: fields.gsub("\n", ""), target_container: target_container})
  end

  def link_to_add_association(name, f, association, template)
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, new_object, child_index: "new_#{association}") do |builder|
      render(template, f: builder)
    end
    link_to(name, 'javascript:void(0);', class: 'add-link-association btn btn-gray btn-add', data: {association: association, content: fields.gsub("\n", "")})
  end

  def linked_product_template_fields(f)
    f.fields_for(:linked_products, LinkedProduct.new, child_index: 'new_linked_product') do |builder|
      render('panel/linked_products/fields', f: builder)
    end
  end

  def post_product_template_fields(f)
    f.fields_for(:post_products, PostProduct.new, child_index: 'new_linked_product') do |builder|
      render('panel/linked_products/fields', f: builder)
    end
  end

  def manual_post_product_template_fields(f)
    f.fields_for(:manual_post_products, ManualPostProduct.new, child_index: 'new_linked_product') do |builder|
      render('panel/linked_products/fields', f: builder)
    end
  end

  def movie_product_template_fields(f)
    f.fields_for(:movie_products, MovieProduct.new, child_index: 'new_linked_product') do |builder|
      render('panel/linked_products/fields', f: builder)
    end
  end

  def manual_training_product_template_fields(f)
    f.fields_for(:manual_training_products, ManualTrainingProduct.new, child_index: 'new_linked_product') do |builder|
      render('panel/linked_products/fields', f: builder)
    end
  end

  def threed_model_product_template_fields(f)
    f.fields_for(:threed_model_products, ThreedModelProduct.new, child_index: 'new_linked_product') do |builder|
      render('panel/linked_products/fields', f: builder)
    end
  end

  def similar_product_template_fields(f)
    f.fields_for(:similar_products, ProductSimilarity.new, child_index: 'new_linked_product') do |builder|
      render('panel/product_similarities/fields', f: builder)
    end
  end

  def active_class(menu_name)
    menu_active?(menu_name) ? 'active' : ''
  end

  def menu_active?(menu_name)
    controller_name = controller.controller_name
    case menu_name
      when 'channels'
        return 'active' if menu_name == controller_name ||
            (%w{posts tv_shows magazines}.include?(controller_name) && params[:channel_id].present?) ||
            %w{episodes}.include?(controller_name)
      when 'media_owners'
        return 'active' if menu_name == controller_name ||
            (%w{posts media_owner_trendings}.include?(controller_name) && params[:media_owner_id].present?)
      when 'tv_shows'
        return 'active' if menu_name == controller_name && params[:channel_id].blank?
      when 'magazines'
        return 'active' if (menu_name == controller_name && params[:channel_id].blank?) ||
            %w{issues issue_pages issue_page_tags}.include?(controller_name)
      when 'media_owner_trendings'
        return 'active' if menu_name == controller_name && params[:media_owner_id].blank?
      when 'threed_ars'
        return 'active' if (menu_name == controller_name || %w{threed_models}.include?(controller_name))
      when 'social_accounts'
        return 'active' if menu_name == controller_name || %w{social_account_followings}.include?(controller_name)
      else
        return 'active' if menu_name == controller_name
    end
  end

  def container_type_selector(object)
    content = object.content

    if content.class.to_s == 'ProductsContainer'
      content.media_owner_id.present? ? 'ComboContainer' : 'ProductsContainer'
    elsif content.class.to_s == 'MediaContainer'
      'MediaContainer'
    end
  end

  def number_to_delimited(number)
    return '' if number.blank? || number == 0
    ActiveSupport::NumberHelper.number_to_delimited(number.to_f.round())
  end
end
