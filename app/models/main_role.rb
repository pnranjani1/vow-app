class MainRole < ActiveRecord::Base
  has_many :permissions
  has_many :authusers, through: :permissions
end
