class Usercategory < ActiveRecord::Base
  before_save :generate_commodity_name
  validates :main_category_id, presence: { message: " - Select Commodity "}

  #has_many :taxes
  belongs_to :authuser
  belongs_to :main_category
  has_many :products
  belongs_to :auth_user_category
  
  def generate_commodity_name
    self.commodity_name = self.main_category.commodity_name
  end
  
  #Description: following method is going to return available categories
  # Sepecific to the logged in user account. 
  #Below written multiple queries can be more compacted ingo a single join query.
  #But  for now let's use multiple queries.
  def self.available_categories(current_user) 
    if Authuser.current.main_roles.first.role_name == "secondary_user"
        commodities = Usercategory.where(:primary_user_id => [Authuser.current.id, Authuser.current.invited_by.id])
        #assigned_cat = current_user.usercategories.pluck(:main_category_id)
        assigned_cat = commodities.pluck(:main_category_id)
        available_categories = MainCategory.select('id, commodity_name').where.not(id: assigned_cat)
        available_categories #returning available_categories
    else
        commodities = Usercategory.where(:primary_user_id => Authuser.current.id)
        #assigned_cat = current_user.usercategories.pluck(:main_category_id)
        assigned_cat = commodities.pluck(:main_category_id)
        available_categories = MainCategory.select('id, commodity_name').where.not(id: assigned_cat)
        available_categories #returning available_categories
    end
  end
  
 end
