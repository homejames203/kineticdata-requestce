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

# require the task sdk
require "#{pwd}/task-sdk/sdk.rb"

# Log file to send +puts+ statements to
@@logfile = "#{pwd}/#{Time.now.strftime('%Y%m%dT%H%M%S%L')}.log"


# temporary env file for testing, will not be present on docker host
env_file = pwd + "/env.list"
if File.exists? env_file
  IO.readlines(env_file).each do |line|
    if line.size > 0 && !line.strip.start_with?("#")
      key_value = line.split("=", 2)
      case key_value.size
      when 2 then ENV[key_value[0]] = key_value[1].strip
      when 1 then ENV[key_value[0]] = ""
      end
    end
  end
end


# Set the custom properties that were set in the environment
@custom = {
  "config_user" => {
    "username" => ENV["config_user.username"],
    "password" => ENV["config_user.password"]
  },
  "db" => {
    "name" => ENV["db.name"],
    "server" => {
      "host" => ENV["db.server.host"],
      "port" => ENV["db.server.port"]
    },
    "user" => {
      "username" => ENV["db.user.username"],
      "password" => ENV["db.user.password"]
    }
  },
  "engine" => {
    "delay" => ENV["engine.delay"],
    "threads" => ENV["engine.threads"],
    "trigger" => ENV["engine.trigger"]
  },
  "source" => {
    "slug" => ENV["source.slug"],
    "server" => ENV["source.server"],
    "user" => {
      "username" => ENV["source.user.username"],
      "password" => ENV["source.user.password"]
    }
  }
}

# Load Settings
@defaults = {
  "server" => ENV["task.url"],
  "config_user" => {
    "username" => "admin",
    "password" => "admin"
  }
}


# Use the Task SDK
sdk = Kinetic::TaskApiV2::SDK.new(@defaults, @custom)

# wait until the web application is alive
sdk.wait_until_alive("/environment")

# Check if the web server is already configured
if JSON.parse(sdk.retrieve_db)['JDBC Driver'] == "org.postgresql.Driver"
  puts "Kinetic Task web server is already configured"
  return
end
puts "Preparing Kinetic Task web server"

# update the database properties
sdk.update_db(
  {
    "hibernate.connection.driver_class" => "org.postgresql.Driver",
    "hibernate.connection.url" => "jdbc:postgresql://#{@custom['db']['server']['host']}:#{@custom['db']['server']['port']}/#{@custom['db']['name']}",
    "hibernate.connection.username" => @custom['db']['user']['username'],
    "hibernate.connection.password" => @custom['db']['user']['password'],
    "hibernate.dialect" => "com.kineticdata.task.adapters.dbms.KineticPostgreSQLDialect"
  })

# Check if the database is already seeded
unless sdk.retrieve_source(@custom['source']['slug']).nil?
  puts "Kinetic Task database is already seeded"
  return
end
puts "Preparing to seed the Kinetic Task database"

# import the license if there is one
sdk.update_license(pwd+"/license.txt")

# create the source
sdk.create_source(
  {
    "name" => @custom['source']['slug'],
    "status" => "Active",
    "type" => "Kinetic Request CE",
    "properties" => {
      "Space Slug" => @custom['source']['slug'],
      "Web Server" => @custom['source']['server'],
      "Proxy Username" => @custom['source']['user']['username'],
      "Proxy Password" => @custom['source']['user']['password']
    },
    "policyRules" => []
  })

# create policy rules
# sdk.create_policy_rule(
#   {
#     "name" => "Test",
#     "type" => "API Access",
#     "rule" => "true",
#     "message" => "You should have access."
#   })
#

# create categories
# sdk.create_category("Jack")

# create users
# sdk.create_user(
#   { "loginId" => "foo",
#     "password" => "bar",
#     "email" => "foo@bar.com"
#   })

# create groups
#sdk.create_group("Test Group")

# import handlers
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
        "api_server" => @custom['source']['server'],
        "api_username" => @custom['source']['user']['username'],
        "api_password" => @custom['source']['user']['password'],
        "space_slug" => @custom['source']['slug']
      },
      "categories" => []
    }
    sdk.update_handler(File.basename(handler_file, ".zip"), body)
  end
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
  # import the file
  sdk.import_tree(File.new(tree, 'rb'))
end

# import routines
Dir[File.dirname(File.expand_path(__FILE__))+"/routines/*"].each do |routine|
  sdk.import_routine(File.new(routine, 'rb'))
end

# update engine properties
sdk.update_engine(
  {
    "Max Threads" => @custom['engine']['threads'],
    "Sleep Delay" => @custom['engine']['delay'],
    "Trigger Query" => @custom['engine']['trigger']
  })

# update web server and configuration user properties
server_properties = {
  "Configurator Username" => @custom['config_user']['username'],
  "Configurator Password" => @custom['config_user']['password']
}
server_properties["Log Level"] = @custom['source']['log_level'] unless @custom['source']['log_level'].nil?
server_properties["Log Size (MB)"] = @custom['source']['log_size'] unless @custom['source']['log_size'].nil?
sdk.update_properties(server_properties)
