class WaveLog < ActiveRecord::Base

  validates_presence_of :timestamp, :body

end

