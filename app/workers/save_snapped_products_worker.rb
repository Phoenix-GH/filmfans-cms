class SaveSnappedProductsWorker
  include Sidekiq::Worker

  def perform(user_id, pids)
    pids_set = Set.new(pids)

    pids_set.each do |pid|
      begin
        SnappedProduct.create(
            product_id: pid,
            user_id: user_id
        )
      rescue ActiveRecord::RecordNotUnique
        retry
      end
    end
  end
end