# the index must be created on elasticsearch first. This Task does not the index
# To create the index:
#   bundle exec rake searchkick:reindex CLASS=ProductKeyword RAILS_ENV=development
task index_product_keywords: :environment do
  puts 'Kicking sidekiq to index product_keywords...'

  IndexProductKeywordsWorker.perform_async()

end
