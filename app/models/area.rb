class Area < ActiveRecord::Base
  acts_as_tree
  acts_as_authorization_object
  
  validates_presence_of :name
  validates_uniqueness_of :name
  
  has_many :plannings, :order => 'end_date DESC'
  
  attr_accessor :project_leaders, :members
  
  accepts_nested_attributes_for :children, :allow_destroy => true
 
  
  class << self
=begin
 Dado un usuario user y un rol role, retorna todas las áreas en las cuales user tiene el role role.
 Ejemplos puede retornar todas las áreas en las cuales el usuario tiene el rol de administrador.  
=end
    def with_role_of_user(user, role)
      return joins(:roles, :users).
          where(:users => {:id => user.id}).
          where(:roles => {:name => role}) 
    end
  end
  
end

