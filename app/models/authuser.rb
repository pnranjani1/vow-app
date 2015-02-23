class Authuser < ActiveRecord::Base
 require 'rubygems'
require 'active_support/core_ext/date/conversions'
  
 # Include default devise modules. Others available are:
  # :confirmable, :lockable and :omniauthable
 
   
  
   after_create :create_role_for_invitees
   after_create :invoke_user_table
   after_create :invoke_address_table
   after_create :invoke_bankdetail_table
   after_create :invoke_membership_table
  #after_update :membership_status
#  after_update :send_admin_mail
  after_update :send_mail
   after_update :send_user_mail
  after_save  :membership_end_date_reminder_mail
  
 
  
  devise :invitable, :database_authenticatable, :registerable,
  :recoverable, :rememberable, :trackable,:validatable, :timeoutable
   
 # validates :date_of_birth, presence: true
  
  has_many :admins
  has_many :customers
  has_many :taxes
  has_many :products
  #has_many :usercategories, dependent: :destroy
  has_many :bills
  
  
  has_many :permissions
  has_many :main_roles, through: :permissions
  
  
  has_many :usercategories
  has_one :auth_user_category
  #has_many :auth_user_categories
  
   has_many :clients, dependent: :destroy
  has_many :users, dependent: :destroy
  
  has_one :address, dependent: :destroy
  has_one :membership, dependent: :destroy
  has_one :bankdetail, dependent: :destroy
 
  #has_many :clients, class_name: 'Client', foreign_key: 'created_by'
 
  accepts_nested_attributes_for :membership
  accepts_nested_attributes_for :address
  accepts_nested_attributes_for :bankdetail
  accepts_nested_attributes_for :clients
  accepts_nested_attributes_for :main_roles
  accepts_nested_attributes_for :users
  accepts_nested_attributes_for :permissions
  accepts_nested_attributes_for :usercategories
    
   
  #def role_symbols
    #current_role.role_name
  #end
  
  
 # def role_symbols
  #  roles = []
   # roles << current_role.role_name.to_sym
    #return roles
  #end
  
  #def role_symbols
   # roles = []
    #roles << MainRole.find(1).role_name.to_sym
    #return roles   
  #end
  
  #has_many :invoice_items
  #def total_profit
   # invoice_items.sum(:profit)
  #end
  
  def self.current
    Thread.current[:authuser]
  end
  def self.current=(authuser)
    Thread.current[:authuser] = authuser
  end
  
 def role_symbols
  main_roles.map do|role|
    role.role_name.underscore.to_sym
 end
end
  
  
  
  def create_role_for_invitees
    if self.name.nil?
     #self.main_roles << MainRole.find_by_role_name("user")
     #self.main_roles << MainRole.where(:role_name => "user")
    self.permissions << Permission.new
     end
  end
  
    
   def invoke_user_table
   if self.name.nil?
      self.users << User.new 
     end
    end
  
   
  
  def invoke_address_table
     if self.name.nil?
       self.build_address
      #create_bankdetail{attributes => {:bank_account_number, :ifsc_code}}
      end
    end
  
  def invoke_bankdetail_table
     if self.name.nil?
       self.build_bankdetail
      end
    end
  
  
  def invoke_membership_table
     if self.name.nil?
       self.build_membership
      end
    end
  
 #def membership_status
  # if self.approved?
   #  self.membership.membership_status = true
   #else
    # self.membership.membership_status = false
    #end
  #end
  
 def active_for_authentication? 
 # if self.sign_in_count > 0
   if self.membership.membership_end_date + 1.days ==  Date.today
    self.approved == false
   else
     super && approved? 
   #end
 end
 end

 def inactive_message 
  # if !approved? && invitation_accepted_at == Time.now-5.minutes
   if !approved? && self.name.present? && sign_in_count == 0
     :not_approved 
   elsif !approved
     :waiting_for_approval
   else
      super 
    end 
  end
  
  def current_role
  end
  
  
  
  
  #def membership_status
   # if self.membership.membership_status == true
    # self.approved = true
   #end
  #end
    
  
 
  # def send_admin_mail
   #  if self.name.present? && sign_in_count == 0 && invitation_accepted_at.to_i == updated_at.to_i
     #if invitation_accepted_at.to_i == updated_at.to_i 
     #if self.name.present? && sign_in_count == 0 && self.bankdetail.bank_account_number.present?
   #  if self.name.present? && self.approved == false && sign_in_count == 0
  # Notification.new_user(self).deliver
  #end
  #end
  
  def send_mail
    if self.invitation_accepted_at_changed?
      Notification.new_user(self).deliver
    end
  end
  
 def send_user_mail
   if self.approved? && self.approved_changed?
 Notification.user_activated_mail(self).deliver
  end
 end
  
  def membership_end_date_reminder_mail
   if self.membership.membership_end_date == Date.today + 2.days
     Notification.membership_end_date_reminder(self).deliver
  end
  end
  
  
  
  
end

