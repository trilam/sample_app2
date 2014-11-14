class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password]) 
      # log the user in and redirect to user's show page
      log_in user
      params[:session][:remember_me] == '1' ? remember(user) : nil
      # redirect_to user == redirect_to user_path(user)
      #redirect_to user
      #redirect_to user_path(user)
      redirect_back_or user
    else 
      # create and show error messge
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url   
  end
end
