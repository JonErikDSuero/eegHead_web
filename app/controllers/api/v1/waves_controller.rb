class Api::V1::WavesController < ApplicationController

  require 'csv'

  skip_before_action :verify_authenticity_token

  def insert
    timestamp = DateTime.parse(params[:timestamp])
    wave_values = params[:wave_csv].parse_csv
    wave = Wave.create(Wave.categorize(wave_values).merge({timestamp: timestamp}))
    render json: {status: wave.errors.blank?, wave: wave}
  end

end
