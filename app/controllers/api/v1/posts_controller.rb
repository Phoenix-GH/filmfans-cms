class Api::V1::PostsController < Api::V1::BaseController
  def show
    if params[:id].to_i > 0
      @post = Post.find(params[:id])
      render json: PostSerializer.new(@post, true).results
    else
      @post = ManualPost.find(params[:id].to_i * -1)
      render json: ManualPostSerializer.new(@post, true).results
    end
  end
end
