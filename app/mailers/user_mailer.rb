class UserMailer < ActionMailer::Base
  default :from => "no.replay.project@gmail.com", :subject => "New account information"
  

  def registration_confirmation(user)  
    @user = user
    mail(:to => @user.email)
  end 
  
end
