namespace :crop_shop do
  task fill_country: :environment do
    puts 'Starting ...'

    ExecutionBenchmark.where(action_date: nil).find_in_batches(batch_size: 1000) do |group|
      ips = Set.new

      group.each do |benchmark|
        unless benchmark.details['remote_ip'].blank?
          ips << benchmark.details['remote_ip']
        end
      end

      info = {}
      error_happened = get_country_info(ips, info)

      update_benchmark(group, info)

      if error_happened
        raise 'Error happened'
      end
    end

    puts "done"
  end

  task generate_missing_sub_benchmarks: :environment do
    query = ExecutionBenchmark.where(main: true).where(sub_benchmark_id: nil).where('action_date >= ?', '2016-12-01')
    total = query.count
    puts "total to process: #{total}"

    processed_count = 0
    query.find_each do |benchmark|
      begin
        controller = Api::V1::SnappedProductsController.new
        controller.capture_from_benchmark(benchmark.id)

        processed_count += 1
        puts "#{processed_count}/#{total}"

        # avoid lockout by visenze (limit number of request/sec)
        sleep(1)
      rescue => e
        puts e.message
        puts e.backtrace.join("\n")
      end
    end
  end

  def get_country_info(ips, info)
    error_happened = false
    ips.each do |ip|
      response = RestClient.get("http://freegeoip.net/json/#{ip}")

      begin
        json = JSON.parse(response)
        info.merge!({
                        ip => {
                            code: json['country_code'],
                            name: json['country_name']
                        }
                    })
      rescue => e
        puts "IP #{ip} .Error (#{e}) parsing json: #{response}"
        error_happened = true
      end

      return error_happened if error_happened
    end
    error_happened
  end

  def update_benchmark(benchmarks, info)
    benchmarks.each do |benchmark|
      attrs = {
          action_date: benchmark.created_at
      }

      unless benchmark.details['remote_ip'].blank?
        ip = benchmark.details['remote_ip']

        unless info[ip].blank?
          attrs.merge!({
                           country_code: info[ip][:code],
                           country_name: info[ip][:name],
                       })
        end
      end

      benchmark.update_attributes(attrs)
    end
  end

end
