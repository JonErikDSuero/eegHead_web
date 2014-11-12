class Api::V1::WavesController < ApplicationController

  require 'csv'

  skip_before_action :verify_authenticity_token

  def insert
    time = DateTime.parse(params[:timestamp])
    waves_values = params[:waves_csv].parse_csv
    waves = Waves.categorize(waves_values)
    render json: {time: time, waves: waves}
  end

end
