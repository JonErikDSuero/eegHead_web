class Site::WavesController < ApplicationController

  skip_before_action :verify_authenticity_token

  def graph

  end

end

