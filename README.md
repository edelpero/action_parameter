[![Code Climate](https://codeclimate.com/github/edelpero/action_parameter.png)](https://codeclimate.com/github/edelpero/action_parameter)

ActionParameter
===============

ActionParameter helps you move all your parameter's logic into it's own class. This way you'll keep your controllers dry and they would be easier to test.

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
rails generate parameter [MODEL_NAME]
```
Will create **app/parameters/[model_name]_parameters.rb**.

####Controller Helpers

- **permitted_params:** Returns an ActionParameter instance.

```ruby
permitted_params(options={})
```

#####Options Hash

 * **options**          - Hash with two valid keys **:class** and **:locals**.
 * **options[:class]**  - Symbol value with the name of the Parameters class you want to use.
 * **options[:locals]** - Hash used to create helper methods available for the ActionParameter instance.

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

####Parameter Helpers

#####Default Helpers

- **params:**          Returns params from the current controller request which instantiated the Parameter class.
- **controller_name:** Returns the controller's name from which the Parameter class was instantiated.
- **action_name:**     Returns the action's name from the controller from which the Parameter class was instantiated.

#####Creating New Helpers

If you want to create new helper methods for you parameters class, just pass a hash using **:locals**. Let say you want to make **@current_user** available for the UserParameter's class, then you'll need to use the **:locals** option to tell the UserParameters class to create a new helper that returns **@current_user**.

```ruby
permitted_params(class: :user, locals: { current_user:   @current_user,
                                         another_helper: @value })
```
This will create **current_user** and **another_helper** methods and they will be available in UserParameters class.

#####Example

```ruby
# app/controllers/people_controllers.rb
class UsersController < ActionController::Base
  def create
    Person.create(permitted_params(locals: { current_user: @current_user }).sign_up)
    # This will call to UserParameters' sign_up method and will also create a
    # helper method named 'current_user' which will return @current_user
  end
end
```

```ruby
# app/parameters/user_parameters.rb
class UserParameters < ActionParameter::Base
  def sign_up
    if current_user # Method created using :locals option
      params.permit!
    else
      params.require(:person).permit(:name, :age)
    end
  end
end
```