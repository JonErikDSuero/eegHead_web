class Course < ActiveRecord::Base

  has_and_belongs_to_many :users
  has_many :videos

  def complete_name
    "#{self.name} (#{self.code})"
  end

end
