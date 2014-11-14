class Site::WavesController < ApplicationController

  skip_before_action :verify_authenticity_token

  def graph
    #@waves = Wave.where(user_id: params[:user_id], video_id: params[:video_id])
  end

end
