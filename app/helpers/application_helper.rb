module ApplicationHelper

 def human_boolean(boolean)
   boolean ? 'Active' : 'Pending For Approval'
end
  
end
