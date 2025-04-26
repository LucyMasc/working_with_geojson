require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../config/environment', __dir__)
abort("The Rails environment is running in production mode!") if Rails.env.production?
Object.send(:remove_const, :ActiveRecord)
require 'rspec/rails'

Rails.root.glob('spec/support/**/*.rb').sort_by(&:to_s).each { |f| require f }
RSpec.configure do |config|
  config.use_active_record = false
  config.include(FactoryBot::Syntax::Methods)
  config.include Request::JsonHelpers, type: :request
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
end
