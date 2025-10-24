require 'simplecov'
require 'simplecov-console'

env = ENV['RAILS_ENV'] || ENV['RACK_ENV'] || 'development'

SimpleCov.coverage_dir 'coverage'
SimpleCov.use_merging true
SimpleCov.minimum_coverage 90
SimpleCov.minimum_coverage_by_file 80

SimpleCov.formatter =
  if env == 'development'
    SimpleCov::Formatter::MultiFormatter.new([
      SimpleCov::Formatter::HTMLFormatter,
      SimpleCov::Formatter::Console
    ])
  else
    SimpleCov::Formatter::Console
  end

SimpleCov.start 'rails' do
  add_filter '/config/'
  add_filter '/spec/'
  add_filter '/features/'
  add_filter '/vendor/'
  add_group 'Models', 'app/models'
  add_group 'Controllers', 'app/controllers'
  add_group 'Helpers', 'app/helpers'
  add_group 'Views', 'app/views'
  add_group 'Jobs', 'app/jobs'
  add_group 'Mailers', 'app/mailers'
end

puts "✅ SimpleCov started (env: #{env})"
