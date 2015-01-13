class Api::V1::VideoSessionsController < ApplicationController

  skip_before_action :verify_authenticity_token

	def upload
	  	video= Video.create(
	      owner_id: params[:owner_id],
	      code: params[:video_code]
	    )
	    render json: {status: video.errors.blank?, video: video}
	end

  def delete

  end

end