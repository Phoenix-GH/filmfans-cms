class Api::V1::SystemsController < Api::V1::BaseController
  def index
    render json: {
        or_feature_count_threshold: Panel::SystemsController::or_feature_count_threshold
    }
  end

  def exchange_rate
    from = exchange_rate_params[:from]
    to = exchange_rate_params[:to]

    rate = 0
    unless from.blank? || to.blank?
      rate = CurrencyService::get_exchange_rate(from, to)
    end

    render json: {
        from: from,
        to: to,
        rate: rate
    }
  end

  private
  def exchange_rate_params
    params.permit(:from, :to)
  end
end