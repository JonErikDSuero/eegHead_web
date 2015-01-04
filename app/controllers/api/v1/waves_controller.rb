require 'csv'

class Api::V1::WavesController < ApplicationController

  skip_before_action :verify_authenticity_token

  def insert
    timestamp = DateTime.parse(params[:timestamp])
    wave_values = params[:wave_csv].parse_csv
    wave = Wave.create(Wave.categorize(wave_values).merge({timestamp: timestamp}))
    render json: {status: wave.errors.blank?, wave: wave}
  end

  def graph_points
    render json: graph_points_hash(params)
  end

  def updates_stream
    response.headers['Content-Type'] = 'text/event-stream'
    sse = ActionController::Live::SSE.new(response.stream, retry: 300, event: "updates_stream")
    begin
      Wave.types.keys.each do |wave_type|
        params[:wave_type] = wave_type
        params[:user_id] = nil
        params[:video_id] = nil
        sse.write(graph_points_hash(params))
      end
    rescue IOError
    ensure
      sse.close
    end
  end


  private

  #private
  def graph_points_hash(params)
    wave_type = params[:wave_type].to_sym
    latest_time = Wave.last.timestamp
    earliest_time = latest_time - 2.minutes
    waves = Wave.where(
      user_id: params[:user_id],
      video_id: params[:video_id],
      timestamp: earliest_time..latest_time,
    ).order('timestamp ASC')

    {
      wave_type: wave_type,
      date_min: earliest_time,
      date_max: latest_time,
      value_min: waves.minimum(wave_type),
      value_max: waves.maximum(wave_type),
      points: waves.map{|w| [w.timestamp, w.try(wave_type) || 0]},
      status: true,
    }
  end

end
