class AreasController < ApplicationController
  respond_to :html, :xml, :js, :json
  autocomplete :user, :login, :full=>true
  before_filter :require_user, :only => [:index_pl, :edit, :members]


=begin rdoc
 se usa para mostrar las áreas al administrador general del sistema.
 En este caso busco solamente las areas que son "raíces" porque las va a ver el administrador
 del sistema que solamente trabaja con áreas padres. 
=end
  # GET /areas
  # GET /areas.xml
  def index
    @areas = Area.where("parent_id IS NULL")
    respond_with(@areas)
  end

=begin 
  se usa para mostrar las áreas de un pl cuando está logueado.
=end
  def index_pl
    @areas = @current_user.areas_with_role('project_leader')
    respond_with(@areas) do |format|
      format.js {render :index}
    end
  end


=begin
 se usa para mostrar los usuarios que son miembros de las áreas que administra.
 TODO queda exactamente igual que el método de más arriba, ver cómo una misma action puede redireccionar a dos views diferentes. 
=end  
  def members
    @areas = @current_user.areas_with_role('project_leader')
    respond_with(@areas)
  end
  
  def new_members
    @area = Area.find(params[:id])
    respond_with(@area)
  end
  
  def add_members
   @errors = []
   @area = Area.find(params[:id])
   @members = params[:area][:members].split(%r{,\s*})
   @added_members = []
   
   @members.each do |member|
     begin
       @user = User.find_by_login(member)
       if @user.has_role?(:administrator)
          raise "El usuario " + @user.login + " no puede ser miembro de un área."       
       else
          @user.has_role!(:member, @area) 
          @added_members = @added_members.concat([@user])     
       end
     rescue => e
       @errors = @errors.concat([e.message])
     end
   end
   respond_with(@added_members)
  end
  
  def remove_members
     @area = Area.find(params[:id])
     @user = User.find(params[:user_id])
     
     @user.has_no_role!(:member, @area)
     respond_with(@user)
  end

  # GET /areas/1
  # GET /areas/1.xml
  def show
    @area = Area.find(params[:id])
    respond_with(@area)
  end

  # GET /areas/new
  # GET /areas/new.xml
  def new
    if params[:area_id]
       @parent_area = Area.find(params[:area_id]) 
       @area = @parent_area.children.build  
    else
       @area = Area.new   
    end
    @area.project_leaders = []
    respond_with(@area)
    
  end

  # GET /areas/1/edit
  def edit
    @area = Area.find(params[:id])
    @area.project_leaders = ""
    User.with_role_in_area('project_leader', @area).each do |user|
      @area.project_leaders = @area.project_leaders + user.login + ", "
    end
    
    @area.children.each do |subarea|
      subarea.project_leaders = ""
      User.with_role_in_area('project_leader', subarea).each do |user|
        subarea.project_leaders = subarea.project_leaders + user.login + ", "
      end
    end
    respond_with(@area)
  end

  # POST /areas
  # POST /areas.xml
  def create
    
    if params[:parent_id]
       @parent_area = Area.find(params[:parent_id]) 
       @area = @parent_area.children.build(params[:area])     
    else
      @area = Area.new(params[:area])      
    end
    
    @errors = []
    
    #Me fijo que haya seleccionado al menos un coordinador válido para el área.
    if !project_leaders_valid?(@area.project_leaders.split(%r{,\s*})) 
        @errors = @errors.concat(["Debe seleccionar un coordinador válido para el área " + @area.name])
    end
    
    if @errors.empty? && @area.valid?
        @area.save
        set_project_leaders(@project_leaders, @area)
    end
    respond_with(@area)
  end

  # PUT /areas/1
  # PUT /areas/1.xml
  def update
    @errors = []
    @area = Area.find(params[:id])
        
    #Me fijo que haya seleccionado al menos un coordinador válido para el área.
    if !project_leaders_valid?(params[:area][:project_leaders].split(%r{,\s*})) 
        @errors = @errors.concat(["Debe seleccionar un coordinador válido para el área " + @area.name])
    end
        
    @area.attributes = params[:area]
    
    if @errors.empty? and @area.valid?
       @area.save
       
       #Actualizo los roles project_leader del área.
       #Primero saco todas los coordinadores que tiene el área.  
       User.with_role_in_area('project_leader', @area).each do |user|
        user.has_no_role!(:project_leaders, @area)
       end
       
       #Agrego todos los nuevos project leaders al área. 
       set_project_leaders(params[:area][:project_leaders].split(%r{,\s*}), @area) 
    end
    respond_with(@area)
  end

  # DELETE /areas/1
  # DELETE /areas/1.xml
  def destroy
    @area = Area.find(params[:id])
    @area.destroy
    respond_with(@area)
  end
  
  private
  
=begin
 Un usuaro es un project_leader válido si no es el administrador general del sistema. 
=end  
  def project_leaders_valid?(project_leaders)
    
    @users = User.where(:login => project_leaders)
    @is_empty = @users.size == 0 
    @is_admin = (@users.size == 1 and @users.first.has_role?(:administrator))
    @result = (!@is_admin and !@is_empty)
    return @result
    
  end
  
  def set_project_leaders(project_leaders, area)
    User.where(:login => project_leaders).each do |pl|
          pl.has_role!(:project_leader, area)
    end
  end
  
end
