class Site::VideosController < ApplicationController

  skip_before_action :verify_authenticity_token

  before_action :is_professor, only: [:new, :create, :destroy]

  def index
    if current_user.present?
      course_ids = current_user.courses.pluck(:id)
    else
      course_ids = Course.all.pluck(:id)
    end
    @videos_list = Video.where(course_id: course_ids).order('created_at DESC').group_by{|v| v.course_id}
  end

  def watch
    if current_user.blank?
      redirect_to videos_url
    end
    @video_session_code = ((Time.now.to_i + SecureRandom.random_number)*10e6).to_i # unique
    @video = Video.find(params[:id] || 1)
    @students_session_codes = @video.video_sessions.where(state: "playing").pluck(:code).uniq

    if current_user.present?
      course_ids = current_user.courses.pluck(:id)
    else
      course_ids = Course.all.pluck(:id)
    end

    @videos_list = Video.where(course_id: course_ids).order('created_at DESC').group_by{|v| v.course_id}
  end

  def new
    @video = Video.new
    @courses = Course.all.map{|c| [c.complete_name, c.id]}
  end

  def create
    @courses = Course.all.map{|c| [c.complete_name, c.id]}
    @video = Video.new(
      link: params[:video][:link],
      course_id: params[:course_id]
    )
    if @video.save
      flash[:success] = 'Video added!'
      redirect_to videos_url
    else
      render 'new'
    end
  end

  def destroy
    Video.find(params[:id]).destroy
    flash[:success] = "Video deleted"
    redirect_to videos_url
  end

  private
    def user_params
      params.require(:video).permit(:link)
    end

    def is_professor
      redirect_to videos_url unless current_user.professor?
    end

end
