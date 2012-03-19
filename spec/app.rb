require 'rails'
require 'action_controller/railtie'
require 'action_view/railtie'

module Assumption
  class Application < Rails::Application
    config.secret_token = '0606ef9eca2318ec13ae836a4f786232'
    config.session_store :cookie_store, :key => "_myapp_session"
    config.active_support.deprecation = :log
    initialize!
  end
end

require 'app/route.rb'
require 'app/controller'


