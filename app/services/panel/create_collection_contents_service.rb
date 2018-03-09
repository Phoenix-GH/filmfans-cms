class Panel::CreateCollectionContentsService
  def initialize(collection, form)
    @collection = collection
    @form = form
  end

  def call
    ActiveRecord::Base.transaction do
      remove_old_collection_contents
      create_new_collection_contents
    end
  end

  private
  def remove_old_collection_contents
    @collection.collection_contents.delete_all
  end

  def create_new_collection_contents
    @form.collection_contents.each_with_index do |content, index|
      model = content[:content_type]
      model_id = content[:content_id]

      if collection_content = model.constantize.find_by(id: model_id)
        @collection.collection_contents.create(
          content: collection_content,
          width: set_width(content),
          position: index
        )
      end
    end
  end

  def set_width(content)
    model = content[:content_type]
    if content[:width] == '1' || %w(ProductsContainer).include?(model)
      'full'
    else
      'half'
    end
  end
end
