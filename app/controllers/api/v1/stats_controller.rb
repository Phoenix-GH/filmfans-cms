class Api::V1::StatsController < Api::V1::BaseController

  def exec_time
    if exec_time_params[:feature] == 'CROP_AND_SHOP'
      store_crop_and_shop_benchmark
    else
      Rails.logger.warn "Unknown feature ID #{exec_time_params[:feature]}"
    end

    render json: {}
  end

  private
  def store_crop_and_shop_benchmark
    return if exec_time_params[:feature_id].blank?
    feature_id = "#{exec_time_params[:feature_id]}"
    if feature_id.start_with?('sub_')
      sub_result_id = feature_id.gsub(/^(sub_)/, '')
      sub_benchmark = BenchmarkMultiObjectCrop.find_by(id: sub_result_id.to_i)
      if sub_benchmark.blank?
        Rails.logger.warn "Cannot find BenchmarkMultiObjectCrop ID #{sub_result_id}"
        return
      end
      sub_benchmark.total_time_from_app = exec_time_params[:spent_millis]
      sub_benchmark.save!
    else
      benchmark = ExecutionBenchmark.find_by(id: feature_id.to_i)
      if benchmark.blank?
        Rails.logger.warn "Cannot find benchmark ID #{feature_id}"
        return
      end
      benchmark.total_time_from_app, = exec_time_params[:spent_millis]
      benchmark.save!
    end
  end

  def exec_time_params
    params.permit(:spent_millis, :feature, :feature_id)
  end
end