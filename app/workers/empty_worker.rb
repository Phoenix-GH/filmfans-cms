class EmptyWorker
  include Sidekiq::Worker

  def perform(seconds)
  	puts "EmptyWorker stars"
  	sleep seconds
  	puts "EmptyWorker ends"
  end
end
