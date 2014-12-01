class Api::V1::WavesController < ApplicationController

  require 'csv'

  skip_before_action :verify_authenticity_token

  def insert
    timestamp = DateTime.parse(params[:timestamp])
    wave_values = params[:wave_csv].parse_csv
    wave = Wave.create(Wave.categorize(wave_values).merge({timestamp: timestamp}))
    render json: {status: wave.errors.blank?, wave: wave}
  end

  def graph_points
    wave_type = params[:wave_type].to_sym
    t = Wave.last.timestamp
    waves = Wave.where(user_id: params[:user_id], video_id: params[:video_id]).where("timestamp > ?", t - 2.minutes).order('timestamp ASC')
    h = {
      date_min: waves.minimum(:timestamp),
      date_max: waves.maximum(:timestamp),
      value_min: waves.minimum(wave_type),
      value_max: waves.maximum(wave_type)
    }
    h.merge!(points: waves.map{|w| [w.timestamp, w.try(wave_type)]})
    render json: h.merge({status: true})
  end
end
