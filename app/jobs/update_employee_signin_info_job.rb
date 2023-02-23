class UpdateEmployeeSigninInfoJob < ActiveJob::Base

  def perform(params)
    EmployeeService.update_signin_info(params)
  end
end
