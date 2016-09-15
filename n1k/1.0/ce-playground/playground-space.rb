#!/usr/bin/env ruby

#-------------------------------------------------------------------------------
# Configure Kinetic Task
#
# - Modify Database configuration
# - Apply License
# - Add Sources (Kinetic CE pointed back to the Space)
# - Add Policy Rules
# - Add Categories
# - Add Users
# - Add Groups
# - Add Handlers and configure
# - Modify the "Notify on Run Error" tree
# - Add Routines and configure
# - Add Trees
# - Modify Engine settings
# - Modify Web Server / Configurator User configuration
#-------------------------------------------------------------------------------

# determine this file's current directory
pwd = File.dirname(File.expand_path(__FILE__))

# require yaml to load the configuration properties
require 'yaml'
# require the task sdk
require pwd+"/task-sdk/sdk.rb"

# Load Settings
@defaults = YAML.load(File.read(pwd+"/settings_default.yaml"))
@custom = YAML.load(File.read(pwd+"/settings_custom.yaml"))


# Use the Task SDK
sdk = Kinetic::TaskApiV2::SDK.new(@defaults, @custom)

# wait until the web application is alive
sdk.wait_until_alive

sdk.update_db
sdk.update_license
sdk.create_source(@custom['space']['slug'], @custom['space']['server'])

sdk.create_policy_rule(
  { "name" => "Test", "type" => "API Access",
    "rule" => "true", "message" => "You should have access."
  })

sdk.create_category("Jack")

sdk.create_user({ "loginId" => "foo", "password" => "bar",
  "email" => "foo@bar.com" })

sdk.create_group("Test Group")


Dir[File.dirname(File.expand_path(__FILE__))+"/handlers/*"].each do |handler|
  handler_file = File.new(handler, 'rb')
  sdk.import_handler(handler_file)

  # Update each handler - need API to get list of info values?
  body = {
    "properties" => {
      "api_server" => @custom['space']['server'],
      "api_username" => @custom['space']['user']['username'],
      "api_password" => @custom['space']['user']['password'],
      "space_slug" => @custom['space']['slug']
    },
    "categories" => []
  }
  sdk.update_handler(File.basename(handler_file, ".zip"), body)
end
Dir[File.dirname(File.expand_path(__FILE__))+"/trees/*"].each do |tree|
  sdk.import_tree(File.new(tree, 'rb'))
end
Dir[File.dirname(File.expand_path(__FILE__))+"/routines/*"].each do |routine|
  sdk.import_routine(File.new(routine, 'rb'))
end

sdk.update_engine
sdk.update_properties
