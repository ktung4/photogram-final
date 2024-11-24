class UsersController < ApplicationController
  skip_before_action(:authenticate_user!, { :only => [:index] })
  before_action :authenticate_user!

  def index
    @list_of_users = User.all.order(username: :asc)
    render(template: "users_html/index")
  end

  def show
    @username = params.fetch("username")
    @the_user = User.find_by(username: @username)
  
    if @the_user.nil?
      redirect_to "/404" # Handle non-existent user
    elsif @the_user.private && @the_user != current_user
      redirect_to users_path, alert: "You're not authorized for that."
    else
      # Render the details page
      render template: "users_html/show"
    end
  end
  
    
  

  def create
    my_input_username = params.fetch("input_username")
    new_user = User.new
    new_user.username = my_input_username
    new_user.save
    redirect_to("/users/" + my_input_username)
  end

  def update
    user_id = params.fetch("user_id")
    my_input_username = params.fetch("input_username")
    the_user = User.where(id: user_id).first
    the_user.username = my_input_username
    the_user.save
    redirect_to("/users/" + my_input_username)
  end

  def destroy
    sign_out(current_user)
    redirect_to("/", { :notice => "Signed out successfully." })
  end


  def follow
    user = User.find(params[:id])
    current_user.sent_follow_requests.create!(recipient: user)
    redirect_to users_path, notice: "Follow request sent."
  end

  def unfollow
    user = User.find(params[:id])
    current_user.sent_follow_requests.find_by(recipient: user).destroy
    redirect_to users_path, notice: "Unfollowed successfully."
  end

  def cancel_follow_request
    user = User.find(params[:id])
    current_user.sent_follow_requests.find_by(recipient: user).destroy
    redirect_to users_path, notice: "Follow request canceled."
  end
  
end
