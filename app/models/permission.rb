class Permission < ActiveRecord::Base
  belongs_to :authuser
  belongs_to :main_role

end
