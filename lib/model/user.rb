require 'bcrypt'

class User < ActiveRecord::Base
  include BCrypt

  def authenticate(attempted_password)
    if self.password == attempted_password
      true
    else
      false
    end
  end
end

#User.destroy_all
#
#@user = User.create(username: "admin")
#@user.password = "admin"
#@user.save
#
#p User.all