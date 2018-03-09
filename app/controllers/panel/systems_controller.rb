class Panel::SystemsController < Panel::BaseController
  skip_before_filter :verify_authenticity_token

  @@threshold = ENV['OR_FEATURE_COUNT_THRESHOLD'] || 0

  def self.or_feature_count_threshold
    @@threshold
  end

  def get_or_feature_count_threshold
    render json: or_feature_count_threshold_json
  end

  def update_or_feature_count_threshold
    @@threshold = or_feature_count_threshold_params[:or_feature_count_threshold]
    render json: or_feature_count_threshold_json
  end

  private

  def or_feature_count_threshold_json
    {
        or_feature_count_threshold: @@threshold,
        from_config: ENV['OR_FEATURE_COUNT_THRESHOLD'] == @@threshold
    }
  end

  def or_feature_count_threshold_params
    params.permit(:or_feature_count_threshold)
  end

end
