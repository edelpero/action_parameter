require 'coveralls'
Coveralls.wear!

require 'bundler'

Bundler.setup
require 'test/unit'
require 'mocha/setup'

# Configure Rails
ENV["RAILS_ENV"] = "test"

require 'active_support'
require 'action_controller'
require 'action_dispatch/middleware/flash'

$:.unshift File.expand_path('../../lib', __FILE__)
require 'action_parameter'

ActionParameter::Routes = ActionDispatch::Routing::RouteSet.new
ActionParameter::Routes.draw do
  get '/:controller(/:action(/:id))'
end

class ApplicationController < ActionController::Base
  include ActionParameter::Routes.url_helpers
end

class ActiveSupport::TestCase
  setup do
    @routes = ActionParameter::Routes
  end
end