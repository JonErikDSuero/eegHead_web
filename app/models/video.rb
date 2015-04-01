class Video < ActiveRecord::Base

  has_many :video_sessions, dependent: :destroy
  belongs_to :course

  before_create :extract_code

  validates_uniqueness_of :code, scope: :owner_id

  YT_LINK_FORMAT = /\A.*(youtu.be\/|v\/|u\/\w\/|embed\/|watch\?v=|\&v=)([^#\&\?]*).*/i

  validates :link, presence: true, format: YT_LINK_FORMAT

  def sessions(user_id)
    VideoSession.where(user_id: user_id, video_id: id).group(:code).pluck(:code, :created_at).uniq
  end

  def extract_code
    if link.to_s.length != 11
      uid = link.match(YT_LINK_FORMAT)
      self.code = uid[2] if uid && uid[2]
    end

    if self.code.to_s.length != 11
      self.errors.add(:code, 'is invalid')
      false
    elsif Video.where(code: self.code).any?
      self.errors.add(:link, 'is not unique.')
      false
    else
      get_additional_info
    end
  end

  def parse_duration
    d = self.duration
    hr = (d/3600).floor
    min = ((d - (hr * 3600)) / 60).floor
    sec = (d - (hr * 3600) - (min * 60)).floor

    hr = '0' + hr.to_s if hr.to_i < 10
    min = '0' + min.to_s if min.to_i < 10
    sec = '0' + sec.to_s if sec.to_i < 10

    hr.to_s + ':' + min.to_s + ':' + sec.to_s
  end

  private
    def get_additional_info
      begin
        client = YouTubeIt::Client.new(dev_key: 'AIzaSyDH0kVkGuxBQ97QdBWI4tf-i35FYS9CPXQ')
        video = client.video_by(code)
        self.title = video.title
        self.duration = video.duration
        self.owner_id = 1;
      rescue
        self.title = "Unknown"
        self.duration = 0
        self.owner_id = 1;
      end
    end

end
