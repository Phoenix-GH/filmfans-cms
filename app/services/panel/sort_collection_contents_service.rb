class Panel::SortCollectionContentsService
  def initialize(collection, params)
    @collection = collection
    @params = params
  end

  def call
    update_all_positions
  end

  private

  def update_all_positions
    @params.each do |key, value|
      @collection.collection_contents
        .find(value[:id])
        .update_attribute(:position ,value[:position])
    end
  end
end
