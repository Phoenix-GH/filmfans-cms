class IndexProductKeywordsWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'elasticsearch_index'

  def perform()
    count = 0
    if ProductKeyword.where(indexed: true).first.blank?
      Sidekiq.logger.info 'Index must be created first, then mark all rows as indexed before the incremental index job can perform'
      Sidekiq.logger.info 'Do something like: bundle exec rake searchkick:reindex CLASS=ProductKeyword RAILS_ENV=<development, production>'
    else
      ProductKeyword.where(indexed: false).find_in_batches(batch_size: 1000) do |batch|
        ProductKeyword.searchkick_index.import(batch)
        ProductKeyword.where(product_id: batch.map { |pk| pk.product_id }).update_all(indexed: true)
        count += batch.length
      end
      Sidekiq.logger.info "Done indexing #{count} product_keywords"
    end
  end

end