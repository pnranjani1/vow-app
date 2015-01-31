class Client < ActiveRecord::Base
  #before_save :generate_unique_reference_key
 # before_save :generate_char

  
  belongs_to :authuser, class_name: "Authuser" #, foreign_key: "created_by"
  has_many :users
  
  accepts_nested_attributes_for :users
  
  
  
  
  #def char
   # self.char = self.authuser.name.slice!(0..3)
  #end
  
  #def digits
   # last_id = Client.last
    #if last_id.nil?
     # self.digits = "000001"
    #else
     # self.digits = last_id.id+1
    #end
  #end
  # def generate_char
 # def generate_unique_reference_key
    #char column data
   # char = self.authuser.name.slice!(0..3)
   #find last id of client
  #  last_id = Client.last
    #if last_id.nil?
    #  digits = 000001
   # else
   #   digits = last_id.id + 1
   # end
    
    #define zero_format - how many zeros before id
     #if digits >= 7
      #  zero_format = digits.slice!(0)
     # elsif digits == 8
       # zero_format = digits.slice!(0,1)
     # elsif digits == 9
      #  zero_format = digits.slice!(0..2)
     # end
      
    #generate unique refernce key
    
    #self.unique_reference_key = char + zero_format
   # end
#end

 
    #str = self.digits.to_i          
      #integer_incremented = integer + 1
      #str = integer_incremented.to_s
      #str = str1.to_i
    #if self.digits.last.nil?
     #self.digits = "000001"
      #else
      #self.digits = self.digits.last + 1
      # self.unique_reference_key =  "#{generate_char}#{zero_format}"
      
    
       end

