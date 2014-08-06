require 'bcrypt'

#DataMapper.setup(:default, "sqlite://#{Dir.pwd}/db.sqlite")
#DataMapper.setup(:default, 'postgres://user:password@hostname/database')
DataMapper.setup(:default, ENV['DATABASE_URL'] || "postgres://user:password@localhost/predictions")

module Fbl
  class User
    include DataMapper::Resource
    include BCrypt

    property :id, Serial, :key => true
    property :username, String, :length => 3..50
    property :password, BCryptHash

    def authenticate(attempted_password)
      if self.password == attempted_password
        true
      else
        false
      end
    end

  end
end

DataMapper.finalize
DataMapper.auto_upgrade!

Fbl::User.destroy

@user = Fbl::User.create(username: "admin")
@user.password = "admin"
@user.save

p Fbl::User.all