class UpdateUserSigninInfoJob < ActiveJob::Base

  def perform(params)
    UserService.update_signin_info(params)
  end
end
