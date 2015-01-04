class Video < ActiveRecord::Base

  validates_uniqueness_of :code, scope: :owner_id

  def sessions(owner_id)
    val = []
    session_sets = VideoSession.where(video_id: id).group_by(&:code).map{|s| s[1]}

    session_sets.each do |session_set| # for each replay
      sessions = session_set.group_by(&:state)
      time_ranges = sessions["playing"].zip(sessions["ended"]).map{|t| t[0].created_at..t[1].created_at}

      val << Wave.where(
        user_id: owner_id,
        video_id: id,
        timestamp: time_ranges,
      )
    end

    val
  end

  def sessions_history
    VideoSession.where(video_id: id).group(:code).pluck(:code, :created_at).uniq
  end

end

