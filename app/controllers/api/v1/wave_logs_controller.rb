class Api::V1::WaveLogsController < ApplicationController

  skip_before_action :verify_authenticity_token

  def all
    render json: WaveLog.all.order('timestamp ASC')
  end


  def insert
    wave_log = WaveLog.create(
      timestamp: DateTime.parse(params[:timestamp]),
      body: params[:body]
    )
    render json: {status: wave_log.errors.blank?, wave_log: wave_log}
  end


  def waves
    start_time = DateTime.parse(params[:start_time])
    end_time = DateTime.parse(params[:end_time])
    render json: Wave.where(timestamp: start_time..end_time).order('timestamp ASC')
  end

end

