require 'test_helper'

UserParameters = Class.new(ActionParameter::Base)
CustomerParameters = Class.new(ActionParameter::Base)

Admin = Module.new
Admin::UserParameters = Class.new(ActionParameter::Base)
Admin::CustomerParameters = Class.new(ActionParameter::Base)

module SharedActionMethods
  def permitted_params_without_arguments
    permitted_params
    render nothing: true
  end

  def permitted_params_with_class_attribute
    permitted_params(class: :customer)
    render nothing: true
  end

  def permitted_params_with_namespaced_class_attribute
    permitted_params(class: 'admin/customer')
    render nothing: true
  end

  def permitted_params_with_locals
    permitted_params.locals(current_user: 'user')
    render nothing: true
  end
end

class Admin::UsersController < ApplicationController
  include ActionParameter::Helpers
  include SharedActionMethods
end

class UsersController < ApplicationController
  include ActionParameter::Helpers
  include SharedActionMethods
end

class ActionParameterTest < ActionController::TestCase
  tests UsersController

  def test_permitted_params_without_arguments_is_an_instance_of_user_parameters
    get :permitted_params_without_arguments
    assert_equal('UserParameters', assigns(:permitted_params).class.to_s)
  end

  def test_permitted_params_with_class_attribute_returns_an_instance_of_customer_parameters
    get :permitted_params_with_class_attribute
    assert_equal('CustomerParameters', assigns(:permitted_params).class.to_s)
  end

  def test_permitted_params_instance_params_helper_method
    get :permitted_params_without_arguments
    assert_equal(@request.params, assigns(:permitted_params).params)
  end

  def test_permitted_params_instance_controller_name_helper_method
    get :permitted_params_without_arguments
    assert_equal(@request.params['controller'], assigns(:permitted_params).controller_name)
  end

  def test_permitted_params_instance_action_name_helper_method
    get :permitted_params_without_arguments
    assert_equal(@request.params['action'], assigns(:permitted_params).action_name)
  end

  def test_permitted_params_with_locals_should_respond_to_current_user_method
    get :permitted_params_with_locals
    assert_equal(true, assigns(:permitted_params).respond_to?(:current_user))
  end
end

class ActionParameterNamespaceTest < ActionController::TestCase
  tests Admin::UsersController

  def test_permitted_params_without_arguments_is_an_instance_of_user_parameters
    get :permitted_params_without_arguments
    assert_equal('Admin::UserParameters', assigns(:permitted_params).class.to_s)
  end

  def test_permitted_params_with_class_attribute_returns_an_instance_of_customer_parameters
    get :permitted_params_with_class_attribute
    assert_equal('CustomerParameters', assigns(:permitted_params).class.to_s)
  end

  def test_permitted_params_with_namespaced_class_attribute_returns_an_instance_of_customer_parameters
    get :permitted_params_with_namespaced_class_attribute
    assert_equal('Admin::CustomerParameters', assigns(:permitted_params).class.to_s)
  end
end
