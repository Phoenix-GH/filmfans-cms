class Api::V1::FbGraphUserDataFetcherService
  # https://developers.facebook.com/docs/graph-api/reference/user/
  FB_FIELDS_TO_FETCH='email,first_name,last_name'

  def initialize(fb_access_token)
    @fb_access_token = fb_access_token
  end

  def call
    get_user_graph_data
    get_encoded_picture

    @fb_user_data
  end

  private

  def get_user_graph_data
    graph = Koala::Facebook::API.new(@fb_access_token)
    picture_data  = graph.get_picture_data('me', type: :large)
    @fb_user_data = graph.get_object("me?fields=#{FB_FIELDS_TO_FETCH}")
    @fb_user_data.merge!("picture" => picture_data)
  end

  def get_encoded_picture
    picture_data = @fb_user_data['picture']['data']
    encoded_image = fetch_user_fb_picture(picture_data)
    @fb_user_data.merge!("encoded_image" => encoded_image)
  end

  def fetch_user_fb_picture(picture_hash)
    return nil if picture_hash['is_silhouette']

    begin
      return "data:#{fetch_content_type(picture_hash['url'])};base64,#{Base64.encode64(open(picture_hash['url']).read)}"
    rescue
      return nil
    end
  end

  def fetch_content_type(url)
    uri = URI.parse(url)

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Get.new(url.to_s)
    http.request(request)['content-type'] || 'image/jpeg'
  end
end

