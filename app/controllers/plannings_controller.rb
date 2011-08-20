class PlanningsController < ApplicationController
  respond_to :html, :xml, :js
  before_filter :require_user, :only => [:index, :create]
  autocomplete :area, :name, :full=>true
  
  # GET /plannings
  # GET /plannings.xml
  def index
    @areas = @current_user.areas_with_role('project_leader')
    respond_with(@areas)
  end

  # GET /plannings/1
  # GET /plannings/1.xml
  def show
    @planning = Planning.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @planning }
    end
  end

  # GET /plannings/new
  # GET /plannings/new.xml
  def new
    @area = Area.find(params[:area_id])
    @planning = @area.plannings.build()

    respond_with(@planning)
    
  end

  # GET /plannings/1/edit
  def edit
    @planning = Planning.find(params[:id])
    respond_with(@planning)
  end

  # POST /plannings
  # POST /plannings.xml
  def create
    
    @errors = []
    
    @area = Area.find_by_name(params[:area_name].split(%r{,\s*}))
    
    if !@area.nil? and @current_user.has_role?(:project_leader,@area)
       @planning = @area.plannings.create(params[:planning])
    else
       @errors[0] = "Usted no coordina el área seleccionada. Por favor seleccione un área que coordine."   
    end
    
    respond_with(@planning)

  end

  # PUT /plannings/1
  # PUT /plannings/1.xml
  def update
    @planning = Planning.find(params[:id])

    respond_to do |format|
      if @planning.update_attributes(params[:planning])
        format.html { redirect_to(@planning, :notice => 'Planning was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @planning.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /plannings/1
  # DELETE /plannings/1.xml
  def destroy
    @planning = Planning.find(params[:id])
    @planning.destroy
    respond_with(@planning)
  end
end
