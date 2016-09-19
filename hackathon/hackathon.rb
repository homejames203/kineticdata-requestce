#!/usr/bin/env ruby

#-------------------------------------------------------------------------------
# Configure Kinetic Task
#
# - Modify Database configuration
# - Apply License
# - Add Source
# - Add Policy Rules
# - Add Categories
# - Add Users
# - Add Groups
# - Add Handlers and configure
# - Add Routines and configure
# - Add Trees
# - Modify Engine settings
# - Modify Web Server / Configurator User configuration
#-------------------------------------------------------------------------------

require 'yaml'

# determine this file's current directory
pwd = File.dirname(File.expand_path(__FILE__))

# require the task api sdk
require "#{pwd}/../../task-sdk-rb/task-sdk"

# Log file to send +puts+ statements to
@@logfile = "#{pwd}/#{Time.now.strftime('%Y%m%dT%H%M%S%L')}.log"

# Load the space specific options
options = YAML.load_file("#{pwd}/env.yaml")
sdk_options = { "log_level" => options.delete("log_level") }

# Use the Task SDK
sdk = Kinetic::TaskApi::SDK.new(options.delete("task_url"), "admin", "admin", sdk_options)


# Wait until the web application is alive
sdk.wait_until_alive("/environment")

# Check if the web server is already configured
if JSON.parse(sdk.retrieve_db)['JDBC Driver'] == "org.postgresql.Driver"
  puts "Kinetic Task web server is already configured"
  return
end
puts "Preparing Kinetic Task web server"

# Update the database properties
sdk.update_db(
  {
    "hibernate.connection.driver_class" => "org.postgresql.Driver",
    "hibernate.connection.url" => "jdbc:postgresql://#{options['db']['server']['host']}:#{options['db']['server']['port']}/#{options['db']['name']}",
    "hibernate.connection.username" => options['db']['user']['username'],
    "hibernate.connection.password" => options['db']['user']['password'],
    "hibernate.dialect" => "com.kineticdata.task.adapters.dbms.KineticPostgreSQLDialect"
  })

# Check if the database is already seeded
unless sdk.retrieve_source(options['source']['slug']).nil?
  puts "Kinetic Task database is already seeded"
  return
end
puts "Preparing to seed the Kinetic Task database"


# Import the license if there is one
sdk.import_license(pwd+"/license.txt")


# Create the source
sdk.create_source(
  {
    "name" => options['source']['slug'],
    "status" => "Active",
    "type" => "Kinetic Request CE",
    "properties" => {
      "Space Slug" => options['source']['slug'],
      "Web Server" => options['source']['server'],
      "Proxy Username" => options['source']['user']['username'],
      "Proxy Password" => options['source']['user']['password']
    },
    "policyRules" => []
  })

# Create policy rules
# sdk.create_policy_rule(
#   {
#     "name" => "Test",
#     "type" => "API Access",
#     "rule" => "true",
#     "message" => "You should have access."
#   })
#

# Create categories
# sdk.create_category("Jack")

# Create users
# sdk.create_user(
#   { "loginId" => "foo",
#     "password" => "bar",
#     "email" => "foo@bar.com"
#   })

# Create groups
# sdk.create_group("Test Group")

# Import handlers
Dir[File.dirname(File.expand_path(__FILE__))+"/handlers/*"].each do |handler|
  handler_file = File.new(handler, 'rb')

  # try up to 3 times in case of time-outs
  tries = 3
  response = nil
  while tries > 0 do
    response = sdk.import_handler(handler_file)
    break if !response.nil? && response.code == 200
    tries -= 1
    sleep 2
  end

  # if import was successful, set the handler properties
  if tries > 0
    # update each handler - need API to get list of info values?
    body = {
      "properties" => {
        "api_server" => options['source']['server'],
        "api_username" => options['source']['user']['username'],
        "api_password" => options['source']['user']['password'],
        "space_slug" => options['source']['slug']
      },
      "categories" => []
    }
    sdk.update_handler(File.basename(handler_file, ".zip"), body)
  end
end

# Import trees
Dir[File.dirname(File.expand_path(__FILE__))+"/trees/*"].each do |tree|
  # fix up the source name in the tree, otherwise the import will fail
  content = File.read(tree).sub(
    /<sourceName>(.*)<\/sourceName>/,
    "<sourceName>#{options['source']['slug']}</sourceName>"
    )
  # save the file
  File.write(tree, content)
  # import the file
  sdk.import_tree(File.new(tree, 'rb'))
end

# Import routines
Dir[File.dirname(File.expand_path(__FILE__))+"/routines/*"].each do |routine|
  sdk.import_routine(File.new(routine, 'rb'))
end

# Update engine properties
sdk.update_engine(
  {
    "Max Threads" => options['engine']['threads'],
    "Sleep Delay" => options['engine']['delay'],
    "Trigger Query" => options['engine']['trigger']
  })

# Update web server and configuration user properties
server_properties = {
  "Configurator Username" => options['config_user']['username'],
  "Configurator Password" => options['config_user']['password']
}
server_properties["Log Level"] = options['source']['log_level'] unless options['source']['log_level'].nil?
server_properties["Log Size (MB)"] = options['source']['log_size'] unless options['source']['log_size'].nil?
sdk.update_properties(server_properties)
