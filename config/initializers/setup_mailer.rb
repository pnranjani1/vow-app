ActionMailer::Base.smtp_settings = {
  :address => "smtp.vatonwheels.com",
  :port => 587,
  :domain => "vatonwheels.com",
  :authentication => "plain",
  :enable_starttls_auto => "true",
  :user_name => "support@vatonwheels.com",
  :password => "abcd1234$",
  :openssl_verify_mode => 'none'
  }