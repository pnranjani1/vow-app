module AuthusersHelper
 
  def gravatar_for(authuser)
      gravatar_id = Digest::MD5::hexdigest(authuser.email.downcase)
     # gravatar_url =  "http://www.gravatar.com/avatar/8d9ab20272393942c14bca88b7438e81"
    gravatar_url =  "http://www.gravatar.com/avatar/#{gravatar_id}"
      image_tag(gravatar_url, alt: authuser.name, class: "gravatar")
  end


end
