module TasksHelper
  
  def get_title
    ret = "<h1>"
    ret += "Tareas de las áreas que "
    if @_action_name == "index"
      ret += "coordina"
    else
      ret += "trabaja"
    end
    ret += "</h1>"
    
    return ret.html_safe
  end

=begin
 Si el nombre del action es index, quiere decir que las taras se estan mostrando para un project leader.
 No puedo en esta instancia preguntar por el rol del usuario logueado porque puede se que un mismo usuario
 tenga tareas para desarrollas y para coordinar y ambar tareas se muestran en diferentes links.
=end  
  def task_for_project_leaders
    return @_action_name == "index" || @_action_name == "edit" || @_action_name == "new" || @_action_name == "create"
  end
  
end
