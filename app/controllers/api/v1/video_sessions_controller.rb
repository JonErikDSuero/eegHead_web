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

  def delete_all
    num_of_deleted = VideoSession.where(code: params[:video_session_code]).delete_all
    render json: {status: (num_of_deleted > 0)}
  end

  def graph_points
    waves = VideoSession.waves(params[:video_session_code], params[:user_id])
    values = Wave.types.keys.map{|wave_type| [
      wave_type,
      {
        y_min: waves.map{|w| w.try(wave_type)}.min,
        y_max: waves.map{|w| w.try(wave_type)}.max,
        points: waves.each.map{|w| [w.index, w.try(wave_type) || 0]},
        status: true,
      }
    ]}
    render json: Hash[values]
  end

end

