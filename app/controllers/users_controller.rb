class UsersController < ApplicationController
  
  respond_to :html, :xml, :js
  before_filter :require_no_user, :only => [:create_admin]
  before_filter :require_user, :only => [:new, :create, :show, :edit, :update, :change_pass]
  
  def new
    @user = User.new
  end
  
=begin
 Crea un usuario y le agrega el rol de administrador.
=end
  def create_admin
    @user = create_user
    @user.has_role!(:administrator)
    if @user.save
      flash[:notice] = "Admin user registered!"
      redirect_back_or_default account_url
    else
      render "user_sessions/new"
    end
  end
  
  def change_pass
    @user = @current_user
    respond_with(@user)
  end
  
  def create
    @user = create_user
    @user.save
    respond_with(@user)
  end
  
  def show
    @user = @current_user
    
  end

  def edit
    @user = @current_user
    respond_with(@user)
  end
  
  def index
    @users = User.all
    respond_with(@users)
  end
  
  def update
    @user = @current_user # makes our views "cleaner" and more consistent
    if @user.update_attributes(params[:user])
      flash[:notice] = "Account updated!"
    end
    if params[:user][:password]
      @partial = 'change_pass'
    else
      @partial = 'edit'
    end
    respond_with(@user)
  end
  
  def destroy
    @user = User.find(params[:id])
    @user.destroy
    respond_with(@user)
  end
  
  private
    def create_user
      @pass = PasswordBuilder.new_password(10)
      params[:user][:password] = @pass
      params[:user][:password_confirmation] = @pass
      return User.new(params[:user])
    end
end
