class Site::VideosController < ApplicationController

  skip_before_action :verify_authenticity_token

  def index
    @videos = Video.order('created_at DESC')
  end

  def watch
    @video_session_code = ((Time.now.to_i + SecureRandom.random_number)*10e6).to_i # unique
    @video = Video.find(params[:id] || 1)
  end

  def new
    @video = Video.new
  end

  def create
    @video = Video.new(user_params)
    if @video.save
      flash[:success] = 'Video added!'
      redirect_to videos_url
    else
      render 'new'
    end
  end

  def destroy
    Video.find(params[:id]).destroy
    flash[:success] = "Video deleted"
    redirect_to videos_url
  end

  private
    def user_params
      params.require(:video).permit(:link)
    end

end
