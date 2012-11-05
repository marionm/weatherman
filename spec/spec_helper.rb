require 'rubygems'
require 'weatherman'

Fog.mock!
Weatherman::AWS.aws_access_key_id = 'test'
Weatherman::AWS.aws_secret_access_key = 'test'

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  config.order = 'random'
end
