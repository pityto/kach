class ApplicationMailer < ActionMailer::Base
  default from: ActionMailer::Base.smtp_settings[:user_name]
  layout 'mailer'
end
