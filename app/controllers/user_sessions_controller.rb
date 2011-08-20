class UserSessionsController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => :destroy
  
=begin
 Cuando no hay usuarios creados aún en la base, no se pide un login sino que se pide que se cree el 
 usuario administrador del sistema. 
 Solamente el administrador será crado de esta manera, luego el resto de los usuarios serán dados de 
 alta en el sistema por el administrador.
=end
  def new
    @user_session = UserSession.new
    if User.count == 0
       @user = User.new
       render "users/new_admin"  
    end
  end
  
  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      flash[:notice] = "Login successful!"
      redirect_back_or_default account_url
    else
      render :action => :new
    end
  end
  
  def destroy
    current_user_session.destroy
    flash[:notice] = "Logout successful!"
    redirect_back_or_default new_user_session_url
  end
end
