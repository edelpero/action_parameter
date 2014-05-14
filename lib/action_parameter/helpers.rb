module ActionParameter
  module Helpers

    protected

      # permitted_params: Returns an ActionParameter instance.
      #
      # == Options
      #
      # * <tt>options</tt>          - Hash with one valid key: class.
      # * <tt>options[:class]</tt>  - Symbol value with the name of the Parameters class you want to use.
      #
      # == Examples
      #
      #     permitted_params(class: customer) # called from UsersController
      #
      #   This will create an instance of CustomerParameters and also will make
      #   'params', 'controller_name' and 'action_name' helper methods
      #   available on the CustomerParameters instace.
      def permitted_params(options = {})
        parameter_class     = permitted_params_class(options[:class])
        @permitted_params ||= parameter_class.new(params)
      end

      # permitted_params_class: Returns a Parameters class.
      #
      # == Options
      #
      # * <tt>class_name</tt> - Symbol value with the name of the Parameters class you want to use.
      #
      # == Examples
      #
      #     permitted_params_class(:customer)  # called from PeopleController
      #     # => CustomerParameters
      #
      #     permitted_params_class(:customers) # called from PeopleController
      #     # => CustomersParameters
      #
      #     permitted_params_class()           # called from PeopleController
      #     # => PersonParameters
      def permitted_params_class(class_name = nil)
        class_name = class_name || self.class.name.sub(/Controller$/, '').singularize
        @permitted_params_class ||= "#{class_name.to_s.camelcase}Parameters".constantize
      end

  end
end