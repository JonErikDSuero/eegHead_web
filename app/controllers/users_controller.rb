class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :logged_in_user, only: [:show, :edit, :update]
  before_action :correct_user, only: [:show, :edit, :update]

  # GET /users
  # GET /users.json
  def index
    redirect_to videos_url
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
    @courses = Course.all
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = "Succesfully Created!"
      redirect_back_or(videos_url)
    else
      render 'new'
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    courses = Course.where(id: params[:course_ids])
    if @user.update(user_params)
      @user.courses = courses
      flash[:success] = "Profile updated"
      redirect_to '/videos'
    else
      render 'edit'
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    # @user.destroy
    # flash[:success] = "User Deleted"
    redirect_to users_url
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    # Confirms a logged-in user. If not logged in, store url trying to access
    # and redirect to login page.
    def logged_in_user
      unless logged_in?
        # {Function}store_location in `sessions_helper`.rb
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end

    # Confirms the correct user. Not just any logged-in user, it has to be
    # the correct one
    def correct_user
      @user = User.find(params[:id])
      # {Function}current_user? in sessions_helper.rb
      redirect_to(root_url) unless current_user?(@user)
    end

end
