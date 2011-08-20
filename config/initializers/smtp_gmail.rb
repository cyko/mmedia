ActionMailer::Base.smtp_settings = {
  :enable_starttls_auto => true,
  :address => "smtp.gmail.com",
  :port => 587,
  :domain => "mycompany.com",
  :authentication => :plain,
  :user_name => "no.replay.project",
  :password => 'Project1234'

}
