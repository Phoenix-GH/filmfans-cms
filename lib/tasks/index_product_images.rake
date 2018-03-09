require 'csv'

namespace :product do
  desc 'Send product image to Vision system for indexing'

  task :index_images => :environment do
    ExportProductImageCsvWorker.perform_async
  end
end