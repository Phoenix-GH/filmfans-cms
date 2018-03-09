class OutOfStockProductQuery < BaseQuery
  def results
    prepare_query
    prepare_results
    paginate_result

    @results
  end

  def total_count
    @total_count
  end

  private

  def prepare_query
    @query_data = ActiveRecord::Base.connection.unprepared_statement {
      ActiveRecord::Base.connection.select_all(
          [
              'SELECT * FROM',
              '(',
              "(#{ProductsContainer.having_out_stock_products.to_sql})",
              'UNION',
              "(#{ManualPost.having_out_stock_products.to_sql})",
              'UNION',
              "(#{Post.having_out_stock_products.to_sql})",
              'UNION',
              "(#{ThreedModel.having_out_stock_products.to_sql})",
              'UNION',
              "(#{IssuePage.having_out_stock_products.to_sql})",
              'UNION',
              "(#{TrendingContent.having_out_stock_products.to_sql})",
              'UNION',
              "(#{HomeContent.having_out_stock_products.to_sql})",
              ') AS results',
              filter_by_sql('type', filters[:search]),
              order_sql('type'),
              paging_sql
          ].join(' ')
      )
    }

    @query_count = ActiveRecord::Base.connection.unprepared_statement {
      ActiveRecord::Base.connection.select_all(
          [
              'SELECT COUNT(id) AS total_count FROM',
              '(',
              "(#{ProductsContainer.having_out_stock_products.to_sql})",
              'UNION',
              "(#{ManualPost.having_out_stock_products.to_sql})",
              'UNION',
              "(#{Post.having_out_stock_products.to_sql})",
              'UNION',
              "(#{ThreedModel.having_out_stock_products.to_sql})",
              'UNION',
              "(#{IssuePage.having_out_stock_products.to_sql})",
              'UNION',
              "(#{TrendingContent.having_out_stock_products.to_sql})",
              'UNION',
              "(#{HomeContent.having_out_stock_products.to_sql})",
              ') AS results',
              filter_by_sql('type', filters[:search])
          ].join(' ')
      )
    }

    @results = @query_data.as_json
    @total_count = @query_count.as_json[0]['total_count'].to_i
  end

  protected
  def paginate_result
    @results = Kaminari.paginate_array(@results, total_count: @total_count).page(page).per(per)
  end

  private
  def prepare_results
    @results = @results.map { |result|
      case result['type']
        when ProductsContainer.name
          {
              :name => "Product Set > #{ProductsContainer.find(result['id']).name}",
              :path_options => {
                  :controller => ProductsContainer.name.to_s.underscore.pluralize,
                  :action => 'edit',
                  :id => result['id']
              }
          }
        when ManualPost.name
          manual_post = ManualPost.find(result['id'])
          {
              :picture => manual_post.image.url,
              :path_options => {
                  :controller => 'media_owner_trendings',
                  :action => 'products',
                  :id => result['id']
              }
          }
        when Post.name
          post = Post.find(result['id'])
          {
              :picture => post.content_picture.url,
              :video => post.content_video.url,
              :path_options => {
                  :controller => Post.name.to_s.underscore.pluralize,
                  :action => 'edit',
                  :id => result['id']
              }
          }
        when ThreedModel.name
          threed_model = ThreedModel.find(result['id'])
          {
              :name => "Threed Model > #{threed_model.description}",
              :path_options => {
                  :controller => ThreedModel.name.to_s.underscore.pluralize,
                  :action => 'edit',
                  :id => threed_model.id,
                  :threed_ar_id => threed_model.threed_ar.id
              }
          }
        when IssuePage.name
          issue_page = IssuePage.find(result['id'])
          {
              :picture => issue_page.image.url,
              :path_options => {
                  :controller => Issue.name.to_s.underscore.pluralize,
                  :action => 'tag_products',
                  :id => issue_page.issue.id,
                  :magazine_id => issue_page.issue.volume.magazine.id,
                  :anchor => "pgid:#{issue_page.id}"
              }
          }
        when TrendingContent.name
          channel = TrendingContent.find(result['id']).trending.channel
          {
              :name => "Channel > #{channel.name} > Trending",
              :path_options => {
                  :controller => Channel.name.to_s.underscore.pluralize,
                  :action => 'edit',
                  :id => channel.id,
                  :step => 'trending'
              }
          }
        when HomeContent.name
          home = HomeContent.find(result['id']).home
          {
              :name => "Home Trending",
              :path_options => {
                  :controller => Home.name.to_s.underscore.pluralize,
                  :action => 'edit',
                  :id => home.id,
                  :step => 'home_contents'
              }
          }
        else
          next
      end
    }
  end
end
