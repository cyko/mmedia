class UserObserver < ActiveRecord::Observer
  
=begin
 Cuando el usuario se crea correctamente, se manda un mail indicándole la clave para ingresar al sistema. 
=end
  def after_create(usuario)
    UserMailer.registration_confirmation(usuario).deliver
  end
  
end
