class User < ActiveRecord::Base
  acts_as_authentic
  acts_as_authorization_subject  :association_name => :roles
  
  def areas_with_role(role)
    @areas = []
    Area.all.each do |area|
      if area.accepts_role?(role, self)
        @areas = @areas + [area]
      end
    end
    return @areas
  end
  
  class << self
        
   def with_no_role (role)
      User.joins(:roles).where("roles.name != ? ", role)
   end
   
   def with_role_in_area(role, area)
       joins(:roles).
          where(:roles => {:authorizable_type => 'Area'}).
          where(:roles => {:authorizable_id => area.id}).
          where(:roles => {:name => role})
    end
    
   def with_role_in_task(role, task)
       joins(:roles).
          where(:roles => {:authorizable_type => 'Task'}).
          where(:roles => {:authorizable_id => task.id}).
          where(:roles => {:name => role})
    end
 end
end
