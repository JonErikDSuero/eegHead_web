class VideoSession < ActiveRecord::Base

  validates_presence_of :video_id, :state, :code

  def self.waves(code, user_id)
    sessions = VideoSession.where(code: code).group_by(&:state)
    time_ranges = sessions["playing"].zip(sessions["ended"]).map{|t| t[0].created_at..t[1].created_at}
    Wave.where(
      user_id: user_id,
      video_id: sessions.first.last.last.video_id,
      timestamp: time_ranges,
    )
  end

end

