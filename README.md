[![Gem Version](https://badge.fury.io/rb/action_parameter.png)](http://badge.fury.io/rb/action_parameter)
[![Build Status](https://travis-ci.org/edelpero/action_parameter.png?branch=master)](https://travis-ci.org/edelpero/action_parameter)
[![Coverage Status](https://coveralls.io/repos/edelpero/action_parameter/badge.png)](https://coveralls.io/r/edelpero/action_parameter)
[![Code Climate](https://codeclimate.com/github/edelpero/action_parameter.png)](https://codeclimate.com/github/edelpero/action_parameter)
[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/edelpero/action_parameter/trend.png)](https://bitdeli.com/free "Bitdeli Badge")

ActionParameter
===============

ActionParameter helps you move all your parameter's logic into it's own class. This way you'll keep your controllers dry and they would be easier to test.

Do you want to learn more about the problem this gem solve? [Read my post here.]( http://edelpero.github.io/blog/2013/10/19/strong-parameters-the-right-way/)

Before
------

```ruby
# app/controllers/users_controllers.rb
class UsersController < ActionController::Base
  def create
    User.create(user_params)
  end

  private
    def user_params
      params.require(:user).permit(:name, :age)
    end
end
```

After
-----

```ruby
# app/controllers/users_controllers.rb
class UsersController < ActionController::Base
  def create
    # It automatically deduces which Parameters class from Controller's name
    User.create(permitted_params.permit)
  end
end
```

```ruby
# app/parameters/user_parameters.rb
class UserParameters < ActionParameter::Base
  def permit
    params.require(:user).permit(:name, :age)
  end
end
```

Install
-------

ActionParameter works with Rails 3.0 onwards and Ruby 1.9.3 onwards. You can add it to your Gemfile with:

```ruby
gem 'action_parameter'
```

Run the bundle command to install it.

Usage
-----

####Generator

```ruby
rails generate parameters [MODEL_NAME]
```
Will create **app/parameters/[model_name]_parameters.rb**.

####Controller Helpers

- **permitted_params:** Returns an ActionParameter instance.

```ruby
permitted_params(options={})
```

#####Options Hash

 * **options**         - Hash with one valid key: **:class**.
 * **options[:class]** - Symbol value with the name of the Parameters class you want to use.

#####Example 1

```ruby
# app/controllers/people_controllers.rb
class PeopleController < ActionController::Base
  def create
    Person.create(permitted_params.permit) # This will call to PersonParameters' permit method
  end
end
```

```ruby
# app/parameters/person_parameters.rb
class PersonParameters < ActionParameter::Base
  def permit
    params.require(:person).permit(:name, :age)
  end
end
```

#####Example 2

```ruby
# app/controllers/people_controllers.rb
class PeopleController < ActionController::Base
  def create
    Person.create(permitted_params(class: :user).sign_up) # This will call to UserParameters' sign_up method
  end
end
```

```ruby
# app/parameters/user_parameters.rb
class UserParameters < ActionParameter::Base
  def sign_up
    params.require(:person).permit(:name, :age)
  end
end
```

####Parameter Class Helpers

#####Default Helpers

- **params:**          Returns params from the current controller request which instantiated the Parameter class.
- **controller_name:** Returns the controller's name from which the Parameter class was instantiated.
- **action_name:**     Returns the action's name from the controller from which the Parameter class was instantiated.

#####Creating New Helpers

If you want to create new helper methods for your parameters class, just call **locals** method over **permitted_params**. Let say you want to make **@current_user** available for the UserParameter's class under the **user** method, then you'll need to use the **locals** method to tell the UserParameters class to create a new helper that returns **@current_user**.

```ruby
permitted_params(class: :user).locals( user:           @current_user,
                                       another_helper: @value )
```
This will create **user** and **another_helper** methods and they will be available in UserParameters class.

#####Example

```ruby
# app/controllers/users_controllers.rb
class UsersController < ActionController::Base
  def create
    User.create(permitted_params.locals(user: @current_user).permit) # This will call to UserParameters' permit method
  end
end
```

```ruby
# app/parameters/user_parameters.rb
class UserParameters < ActionParameter::Base
  def permit
    if user.admin?
        params.require(:person).permit(:name, :age, :admin)
    else
        params.require(:person).permit(:name, :age)
    end
  end
end
```

RSpec
-----

This example shows how to test using RSpec. 

Theses tests require your **application.rb** configured to **config.action_controller.action_on_unpermitted_parameters = :raise**.

```ruby
# spec/parameters/user_parameters_spec.rb
require "spec_helper"

describe UserParameters do
  describe ".permit" do
    describe "when permitted parameters" do
      it "returns the cleaned parameters" do
        user_params = { first_name: "John", last_name: "Doe" }
        params = ActionController::Parameters.new(user: user_params)

        permitted_params = UserParameters.new(params).permit

        expect(permitted_params).to eq user_params.with_indifferent_access
      end
    end

    describe "when unpermitted parameters" do
      it "raises error" do
        user_params = { foo: "bar" }
        params = ActionController::Parameters.new(user: user_params)

        expect{ UserParameters.new(params).permit }.
          to raise_error(ActionController::UnpermittedParameters)
      end
    end
  end
end

```

