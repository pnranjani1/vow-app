class Authuser < ActiveRecord::Base
 
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :customers
  has_many :taxes
  has_many :products
  #has_many :usercategories, dependent: :destroy
  has_many :bills
  has_many :permissions, dependent: :destroy
  has_many :main_roles, through: :permissions
  
  has_many :usercategories
  has_many :main_categories, through: :usercategories
  
  has_many :clients, dependent: :destroy
  has_many :users, dependent: :destroy
  has_one :address, dependent: :destroy
  has_one :membership, dependent: :destroy
  has_one :bankdetail, dependent: :destroy
 
 
  accepts_nested_attributes_for :membership
  accepts_nested_attributes_for :address
  accepts_nested_attributes_for :bankdetail
  accepts_nested_attributes_for :clients
  accepts_nested_attributes_for :main_roles
  accepts_nested_attributes_for :users
  accepts_nested_attributes_for :permissions
    
  def role_symbols
    main_roles.map do|role|
      role.role_name.underscore.to_sym
    end
  end
  
  
  
   
 
end
