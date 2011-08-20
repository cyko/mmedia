module AreasHelper
  
  def get_members(area)
    @users = User.with_role_in_area(:member, area)
  end
  
end
