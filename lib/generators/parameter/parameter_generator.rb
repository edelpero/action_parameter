require 'rails/generators'
require 'rails/generators/named_base'

class ParameterGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('../templates', __FILE__)

  def parameter
    template "parameter_class.rb", "app/parameters/#{name.underscore}_parameters.rb"
  end

end
