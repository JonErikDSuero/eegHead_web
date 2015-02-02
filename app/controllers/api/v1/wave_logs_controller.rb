class Api::V1::WaveLogsController < ApplicationController

  skip_before_action :verify_authenticity_token

  def insert
    wave_log = WaveLog.create(
      timestamp: DateTime.parse(params[:timestamp]),
      body: params[:body]
    )
    render json: {status: wave_log.errors.blank?, wave_log: wave_log}
  end

end

