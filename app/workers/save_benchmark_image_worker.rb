class SaveBenchmarkImageWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'benchmark'

  def perform(benchmark_id, image_params)
    @image_params = {
        image: image_params['image']
    }

    if image_params['image_parameters']
      @image_params.merge!(
          {
              image_parameters: {
                  x: image_params['image_parameters']['x'],
                  y: image_params['image_parameters']['y'],
                  width: image_params['image_parameters']['width'],
                  height: image_params['image_parameters']['height']
              }
          })
    end

    begin
      save(benchmark_id)
    rescue => e
      Sidekiq.logger.error e.message
      st = e.backtrace.join("\n")
      Sidekiq.logger.error st
    ensure
      TempFileHelper::delete_quite(@decoded_file)
    end
  end

  private

  def save(benchmark_id)
    ActiveRecord::Base.transaction do
      benchmark = ExecutionBenchmark.find(benchmark_id)
      unless benchmark.image.file.present?
        @decoded_file = TempFileHelper::create_from_base64(@image_params[:image].to_s)
        benchmark.image = @decoded_file
        benchmark.save!
      end
    end
  end

end