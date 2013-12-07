module ActionParameter
  class Base

    attr_accessor :params

    # initialize: Initialize parameter class and creates controller_name and action_name helpers.
    #
    # == Options
    #
    # * <tt>params</tt> - The ActionController::Parameters instance from the controller who initialize this.
    def initialize(params)
      @params = params
      create_base_helpers
    end

    # locals: Creates helper methods for the ActionParameter instace.
    #
    # == Options
    #
    # * <tt>locals</tt> - Hash used to create helper methods available for the ActionParameter instance.
    #
    # == Examples
    #
    # * locals(new_method: @value, another_method: @other_value)
    #   # => 'ActionParameter instace'
    #
    # Returns the ActionParameter instace.
    def locals(locals = {})
      create_methods(locals)
      self
    end

    protected

      # create_base_helpers: Creates controller_name and action_name helper methods, every time an ActionParameter instace is created.
      def create_base_helpers
        locals = { controller_name: params[:controller],
                   action_name:     params[:action] }
        create_methods(locals)
      end

      # create_methods: Creates instance methods using locals hash's keys and values, params[:controller] and params[:action].
      #
      # == Options
      #
      # * <tt>locals</tt> - Hash used to create helper methods available for the ActionParameter instance. Methods will be named using the hash keys and they'll return the hash values.
      #
      # == Examples
      #
      #     create_methods(current_user: @user, another_key: @another_variable)
      #
      #   Will create 'current_user', 'another_key', 'controller_name' and 'action_name' instance methods.
      #   This methods will be aviable only in the current parameter class where create_method was called.
      #   'current_user'    will return @user.
      #   'another_key'     will return @another_variable
      #   'controller_name' will return the controller instance's name
      #   'action_name'     will return the controller action instance's name
      def create_methods(locals = {})
        locals = {} unless locals

        klass = class << self; self; end

        locals.each do |method_name, value|
          klass.send(:define_method, method_name) do
            value
          end
        end
      end

  end
end