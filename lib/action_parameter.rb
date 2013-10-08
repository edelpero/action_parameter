require 'action_pack'
require 'active_support'
require 'action_parameter/railtie' if defined?(Rails)

module ActionParameter
  extend ActiveSupport::Autoload

  autoload :Base,    'action_parameter/base.rb'
  autoload :Helpers, 'action_parameter/helpers.rb'

end
