class Api::V1::VideoSessionsController < ApplicationController

  skip_before_action :verify_authenticity_token

  def insert
    video_session = VideoSession.create(
      user_id: params[:user_id],
      video_id: params[:video_id],
      state: params[:video_session_state],
      code: params[:video_session_code].to_i*100 + params[:replays].to_i, # unique
    )
    render json: {status: video_session.errors.blank?, video_session: video_session}
  end

  def graph_points # requires: video_id, owner_id
    waves = VideoSession.waves(params[:video_session_code], params[:user_id])
    values = Wave.types.keys.map{|wave_type| [
      wave_type,
      {
        y_min: waves.minimum(wave_type),
        y_max: waves.maximum(wave_type),
        points: waves.each_with_index.map{|w, i| [i, w.try(wave_type) || 0]},
        status: true,
      }
    ]}
    render json: Hash[values]
  end

end

