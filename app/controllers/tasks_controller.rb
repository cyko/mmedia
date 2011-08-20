class TasksController < ApplicationController
  respond_to :html, :xml, :js
  before_filter :require_user, :only => [:index, :index_member]
  # GET /tasks
  # GET /tasks.xml
  def index
    @areas = @current_user.areas_with_role('project_leader')
    respond_with(@areas)
  end
  
  def index_member
    @areas = @current_user.areas_with_role('member')
    respond_with(@areas) do |format|
      format.js {render :index}
    end
  end

  # GET /tasks/1
  # GET /tasks/1.xml
  def show
    
    @task = Task.find(params[:id])
    respond_with(@task)

  end

  # GET /tasks/new
  # GET /tasks/new.xml
  def new
   @planning = Planning.find(params[:planning_id])
   @task = @planning.tasks.build()
   @developments = ""
    respond_with(@task)
  end

  # GET /tasks/1/edit
  def edit
    @task = Task.find(params[:id])
    @developments = ""
    User.with_role_in_task(:development, @task).each do |development|
      @developments = @developments + development.login + ", "
    end
    
    respond_with(@task)
  end

  # POST /tasks
  # POST /tasks.xml
  def create
    @errors = []
    @planning = Planning.find_by_name(params[:planning].split(%r{,\s*}))
    @task = @planning.tasks.create(params[:task])
    @developments = params[:developments].split(%r{,\s*})
    
    User.where(:login => @developments).each do |user|
          if user.has_role?(:member, @planning.area)
            user.has_role!(:development, @task)            
          else
            @errors = @errors.concat([user.login + " is´t member of " + @planning.area.name] + ".")          
          end
    end

    respond_with(@task)
  end

  # PUT /tasks/1
  # PUT /tasks/1.xml
  def update
    @task = Task.find(params[:id])

    respond_to do |format|
      if @task.update_attributes(params[:task])
        format.html { redirect_to(@task, :notice => 'Task was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @task.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /tasks/1
  # DELETE /tasks/1.xml
  def destroy
    @task = Task.find(params[:id])
    @task.destroy
    respond_with(@task)
  end
end
