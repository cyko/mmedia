class Task < ActiveRecord::Base
  acts_as_authorization_object
  
  belongs_to :planning
  
  validates_presence_of :name

end
