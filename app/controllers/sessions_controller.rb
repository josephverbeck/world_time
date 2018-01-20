class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.where(username: params[:session][:email].downcase).first
    if user && user.authenticate(params[:session][:password])
      log_in user
      redirect_to addresses_path
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    log_out
    redirect_to root_path
  end

end
