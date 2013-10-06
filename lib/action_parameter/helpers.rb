module ActionParameter
  module Helpers

    protected

      # permitted_params: Returns an ActionParameter instance.
      #
      # == Options
      #
      # * <tt>options</tt>          - Hash with two valid keys: class and locals.
      # * <tt>options[:class]</tt>  - Symbol value with the name of the Parameters class you want to use.
      # * <tt>options[:locals]</tt> - Hash used to create helper methods available for the ActionParameter instance.
      #
      # == Examples
      #
      #     permitted_params(class: customer, locals: { current_user: @user }) # called from UsersController
      #   
      #   This will create an instance of CustomerParameters and also will make
      #   'current_user', 'params', 'controller_name' and 'action_name' helper methods
      #   available on the CustomerParameters instace.
      def permitted_params(options = {})
        parameter_class     = permitted_params_class(options[:class])
        @permitted_params ||= parameter_class.new(params, options[:locals])
      end

      # permitted_params_class: Returns a Parameters class.
      #
      # == Options
      #
      # * <tt>options[:class]</tt> - Symbol value with the name of the Parameters class you want to use.
      #
      # == Examples
      #
      #     permitted_params_class(class: :customer)  # called from PeopleController
      #     # => CustomerParameters 
      #
      #     permitted_params_class(class: :customers) # called from PeopleController
      #     # => CustomersParameters
      #
      #     permitted_params_class()                  # called from PeopleController
      #     # => PersonParameters
      def permitted_params_class(options = {})
        class_name                = options[:class].to_s || params[:controller].to_s.singularize
        formatted_class_name      = class_name.camelcase
        @permitted_params_class ||= "#{formatted_class_name}Parameters".constantize
      end

  end
end