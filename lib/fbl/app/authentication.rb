require 'model/user'

module Fbl
  class App < Sinatra::Base
    use Rack::Session::Cookie, secret: "nothingissecretontheinternet"

    use Warden::Manager do |config|
      config.serialize_into_session { |user| user.id }
      config.serialize_from_session { |id| User.get(id) }

      config.scope_defaults :default,
                            strategies: [:password],
                            action: 'auth/unauthenticated'
      config.failure_app = self
    end

    Warden::Manager.before_failure do |env, opts|
      env['REQUEST_METHOD'] = 'POST'
    end

    Warden::Strategies.add(:password) do
      def valid?
        params['user'] && params['user']['username'] && params['user']['password']
      end

      def authenticate!
        user = User.first(username: params['user']['username'])

        if user.nil?
          fail!("The username you entered does not exist.")
        elsif user.authenticate(params['user']['password'])
          success!(user)
        else
          fail!("Could not log in")
        end
      end
    end

    get '/auth/login' do
      slim :'authentication/login'
    end

    post '/auth/login' do
      env['warden'].authenticate!

      if session[:return_to].nil?
        redirect '/'
      else
        redirect session[:return_to]
      end
    end

    get '/auth/logout' do
      env['warden'].raw_session.inspect
      env['warden'].logout
      redirect '/'
    end

    post '/auth/unauthenticated' do
      session[:return_to] = env['warden.options'][:attempted_path]
      redirect '/auth/login'
    end
  end
end