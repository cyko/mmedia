class Planning < ActiveRecord::Base
  belongs_to :area
  has_many :tasks
  
  validates_presence_of :start_date
  validate :end_date_cannot_be_less_than_start_date
  validates_presence_of :name
  validates_uniqueness_of :name
  
  attr_accessor :area_name
  
  def end_date_cannot_be_less_than_start_date
    errors.add(:end_date, "can´t be less than start date.") if
          !end_date.blank? and end_date < start_date 
  end
  
  def area_name
    return self.area.name
  end
end
