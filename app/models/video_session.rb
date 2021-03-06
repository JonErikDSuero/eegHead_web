class VideoSession < ActiveRecord::Base

  belongs_to :user
  belongs_to :video

  validates_presence_of :video_id, :state, :code

  def self.waves(code, user_id) # Erik, refactor, messy code
    all_waves = []
    time0 = nil
    time1 = nil
    time_offset = 0
    s = 0
    sessions = VideoSession.where(code: code)

    sessions.each do |session|
      if session.state == 'playing'
        time0 = session.created_at + s.seconds - 4.hours
        s = 1 # shift by 1 for the next time ranges
      elsif session.state == 'paused'
        time1 = session.created_at - 4.hours
        waves = Wave.where(timestamp: time0..time1)
        waves.each do |wave|
          wave.index = (wave.timestamp - time0 + time_offset).to_i
        end
        time_offset = waves.last.index + 1
        all_waves += waves
      end
    end
    all_waves
  end

  def delete_all()
    VideoSession.where(code: code).delete_all
  end

end
