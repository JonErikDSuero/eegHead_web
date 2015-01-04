class Video < ActiveRecord::Base

  validates_uniqueness_of :code, scope: :owner_id

  def sessions
    VideoSession.where(video_id: id).group(:code).pluck(:code, :created_at).uniq
  end

end

