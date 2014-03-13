require 'rubygems'
require 'json-schema'

errors = JSON::Validator.fully_validate('stripped_schema.json', 'data_to_validate.json')

puts errors
