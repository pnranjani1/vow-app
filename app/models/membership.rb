class Membership < ActiveRecord::Base
  belongs_to :authuser
end
