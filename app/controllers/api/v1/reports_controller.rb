class Api::V1::ReportsController < Api::V1::BaseController
  LINKSHARE_USERNAME = 'Ulab'
  LINKSHARE_PASSWORD = 'Sh0pit00'
  LINKSHARE_API_URL = 'https://api.rakutenmarketing.com'
  LINKSHARE_MID = '3267514'
  LINKSHARE_TOKEN_AUTH = 'Basic alNuVGFWdVBwWnZJTUxmWnRXcU5Hb2QzeXMwYTpud0taZ0RIYVZPMmE4Z2hucjZpR1RUNU43REVh'

  CF_TOKEN_AUTH = 'fa63078fc3844fc99b662505ebfb36b8'
  CF_API_URL = 'https://api.commissionfactory.com'

  def sales
    transactions = []
    error = ''
    begin
      date_params = sale_params
      from_date = date_params[:from_date]
      to_date = date_params[:to_date]
    rescue
      render json: {
        error: 'Params are invalid'
      }
      return
    end

    # All transactions from all affiliates
    all_transactions = []
    all_transactions = all_transactions + get_linkshare_transactions(from_date, to_date, 'USD', 'realtime')
    all_transactions = all_transactions + get_cf_transactions(from_date, to_date)
    render json: json_result(all_transactions)
  end

  private

  def sale_params
    params.permit(:from_date, :to_date)
  end

  def get_linkshare_token
    RestClient.post(
        "#{LINKSHARE_API_URL}/token",
        {
            grant_type: 'password',
            username: LINKSHARE_USERNAME,
            password: LINKSHARE_PASSWORD,
            scope: LINKSHARE_MID
        },
        {
            content_type: 'application/x-www-form-urlencoded',
            accept: :json,
            authorization: LINKSHARE_TOKEN_AUTH
        }
    ) { |response|
      case response.code
        when 200
          token_info = JSON.parse(response.body)
          token_info['access_token']
      end
    }
  end

  def get_linkshare_transactions(from_date, to_date, currency, type)
    transactions = []

    # Get linkshare token
    linkshare_token = get_linkshare_token

    unless linkshare_token.blank?
      # Get linkshare transactions
      transaction_params = {
          process_date_start: DateTime.parse(from_date).strftime('%Y-%m-%d %H:%M:%S'),
          process_date_end: DateTime.parse(to_date).strftime('%Y-%m-%d %H:%M:%S'),
          currency: currency,
          type: type
      }.to_param

      headers = {
          authorization: "Bearer #{linkshare_token}"
      }

      linkshare_transactions = get_transactions_from_affiliate("#{LINKSHARE_API_URL}/events/1.0/transactions", transaction_params, headers)
      unless linkshare_transactions[:error].blank?
        transactions = linkshare_transactions[:transactions]
      end
    end

    # if transactions.blank?
    #   sample_dates = [28, 28, 27, 26, 25, 24, 24, 24, 24, 23, 22, 21, 20, 19, 18, 18, 16, 12, 11, 10, 10, 10, 10, 10, 9, 8, 7]
    #   sample_amounts = [100, 200, 120, 400, 800, 732.2, 1092, 233, 402, 466, 872, 567, 120, 1293, 584, 999, 777, 2938, 843, 984, 595, 777, 192, 89, 912, 823, 721]
    #   sample_dates.each_with_index { |d, index|
    #     transactions << sample_data(d, sample_amounts[index])
    #   }
    # end

    transactions
  end

  def get_cf_transactions(from_date, to_date)
    transactions = []

    # Get commission junction transactions
    transaction_params = {
        fromDate: from_date,
        toDate: to_date,
        apiKey: CF_TOKEN_AUTH
    }.to_param

    cf_transactions = get_transactions_from_affiliate("#{CF_API_URL}/v1/merchant/transactions", transaction_params, {})

    unless cf_transactions[:error].blank?
      transactions = cf_transactions[:transactions]
    end

    transactions
  end

  def get_transactions_from_affiliate(url, params, headers)
    data = {
        error: '',
        transactions: []
    }

    RestClient.get("#{url}?#{params}", headers) { |res|
      case res.code
        when 200
          json_transactions = JSON.parse(res.body)

          unless json_transactions.blank?
            data[:transactions] << json_transactions
          end
        else
          data[:error] = 'Linkshare get transactions error'
      end
    }

    data
  end

  def json_result(transactions)
    {
        message: 'Successful',
        results: convert_results(transactions),
        status_code: '200'
    }
  end

  def convert_results(transactions)
    mapped_transactions = transactions.map { |t|
      sale_amount = t['sale_amount']
      quantity = t['quantity']
      date = Date.parse(t['process_date'])

      {
          date: date.strftime('%Y-%m-%d'),
          result: sale_amount * quantity
      }
    }.reverse

    grouped_transactions = mapped_transactions.group_by { |t| t[:date] }

    data_avg_revenue_per_sale = grouped_transactions.map { |k, v|
      date = Date.parse(k)
      {
          day: date.strftime('%-d'),
          month: date.strftime('%-m'),
          result: v.inject(0) { |sum, i| sum += i[:result] }.to_f / v.count
      }
    }

    data_sales_vs_scans = grouped_transactions.map { |k, v|
      no_transactions = v.count
      no_scans = 30
      date = Date.parse(k)
      {
          day: date.strftime('%-d'),
          month: date.strftime('%-m'),
          no_transactions: no_transactions,
          no_scans: no_scans,
          result: no_transactions.to_f / no_scans.to_f * 100
      }
    }

    data_total_revenue = grouped_transactions.map { |k, v|
      date = Date.parse(k)
      {
          day: date.strftime('%-d'),
          month: date.strftime('%-m'),
          result: v.inject(0) { |sum, i| sum += i[:result] }
      }
    }

    data_transactions = grouped_transactions.map { |k, v|
      date = Date.parse(k)
      {
          day: date.strftime('%-d'),
          month: date.strftime('%-m'),
          result: v.count
      }
    }

    no_avg_revenue_per_sale = data_avg_revenue_per_sale.inject(0) { |sum, t| sum += t[:result] }.to_f / data_avg_revenue_per_sale.count
    if no_avg_revenue_per_sale.blank? || no_avg_revenue_per_sale.nan?
      no_avg_revenue_per_sale = 0
    end

    {
        data_avg_revenue_per_sale: data_avg_revenue_per_sale,
        data_sales_vs_scans: data_sales_vs_scans,
        data_transactions: data_transactions,
        data_total_revenue: data_total_revenue,
        growth_percent_avg_revenue_per_sale: 0,
        growth_percent_sales_vs_scans: 0,
        growth_percent_total_revenue: 0,
        growth_percent_transactions: 0,
        no_avg_revenue_per_sale: no_avg_revenue_per_sale,
        no_sales_vs_scans: data_sales_vs_scans.inject(0) { |sum, t| sum += t[:result] },
        no_total_revenue: data_total_revenue.inject(0) { |sum, t| sum += t[:result] },
        no_transactions: data_transactions.inject(0) { |sum, t| sum += t[:result] }
    }
  end

  def sample_data(i, amount)
    {
        etransaction_id: 'c123456d789ccc01234aae56e78d9ea0',
        advertiser_id: 1111,
        sid: 22222,
        order_id: "333333333#{i}",
        member_id: '444444',
        sku_number: '5555555',
        sale_amount: amount,
        quantity: 1,
        commissions: 0,
        process_date: "Wed Apr #{i} 2014 03:07:13 GMT+0000 (UTC)",
        transaction_date: "Wed Apr #{i + 1} 2014 03:07:00 GMT+0000 (UTC)",
        transaction_type: 'realtime',
        product_name: 'Something really fancy',
        u1: 'adc99999999cda',
        currency: 'USD',
        is_event: 'Y'
    }.as_json
  end
end