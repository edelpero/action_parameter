require 'rails/railtie'

module ActionParameter
  class Railtie < Rails::Railtie

    initializer "action_parameter.helpers" do |app|
      ActiveSupport.on_load :action_controller do
        include ActionParameter::Helpers
      end
    end

  end
end
