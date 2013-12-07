### 0.0.2

* enhancements
  * Adds `locals` method to permitted_params to create helpers methods on ActionParameter

* deprecations
  * `permitted_params(locals: {})` in favor of `permitted_params.locals({})`
  * `rails g parameter` rails' generator in favor of `rails g parameters`