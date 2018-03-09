class Api::Braintree::BraintreeController < ActionController::Base

  def client_token
    render json: Braintree::ClientToken.generate
  end

  def checkout
    amount = params[:amount] || "100.00"

    result = Braintree::Transaction.sale(
      amount: amount,
      payment_method_nonce: params[:payment_method_nonce],
      options: {
        submit_for_settlement: true
      }
    )

    if result.success?
      render json: { success: result.transaction.status }
    else
      render json: { error: result.errors }
    end
  end
end
