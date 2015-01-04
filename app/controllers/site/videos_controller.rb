class Site::VideosController < ApplicationController

  skip_before_action :verify_authenticity_token

  def watch
    @video_session_code = ((Time.now.to_i + SecureRandom.random_number)*10e6).to_i # unique
    @video = Video.find(params[:id] || 1)
  end

end

