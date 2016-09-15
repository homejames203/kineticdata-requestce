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

# update the database properties
sdk.update_db

# import the license if there is one
sdk.update_license(pwd+"/license.txt")

# create the source
sdk.create_source(@custom['source']['slug'], @custom['source']['server'])

# create policy rules
sdk.create_policy_rule(
  { "name" => "Test", "type" => "API Access",
    "rule" => "true", "message" => "You should have access."
  })

# create categories
sdk.create_category("Jack")

# create users
sdk.create_user({ "loginId" => "foo", "password" => "bar",
  "email" => "foo@bar.com" })

# create groups
sdk.create_group("Test Group")

# import handlers
Dir[File.dirname(File.expand_path(__FILE__))+"/handlers/*"].each do |handler|
  handler_file = File.new(handler, 'rb')
  sdk.import_handler(handler_file)

  # update each handler - need API to get list of info values?
  body = {
    "properties" => {
      "api_server" => @custom['source']['server'],
      "api_username" => @custom['source']['user']['username'],
      "api_password" => @custom['source']['user']['password'],
      "space_slug" => @custom['source']['slug']
    },
    "categories" => []
  }
  sdk.update_handler(File.basename(handler_file, ".zip"), body)
end

# import trees
Dir[File.dirname(File.expand_path(__FILE__))+"/trees/*"].each do |tree|
  # fix up the source name in the tree, otherwise the import will fail
  content = File.read(tree).sub(
    /<sourceName>(.*)<\/sourceName>/,
    "<sourceName>#{@custom['source']['slug']}</sourceName>"
    )
  # save the file
  File.write(tree, content)
  sdk.import_tree(File.new(tree, 'rb'))
end

# import routines
Dir[File.dirname(File.expand_path(__FILE__))+"/routines/*"].each do |routine|
  sdk.import_routine(File.new(routine, 'rb'))
end

# update engine properties
sdk.update_engine

# update web server and configuration user properties
sdk.update_properties
