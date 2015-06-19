
require 'singleton' # For late_time

require './lib/mini_rake/task'
require './lib/mini_rake/file_task'
require './lib/mini_rake/task_manager'
require './lib/mini_rake/application'
require './lib/mini_rake/mini_rake_module'
require './lib/mini_rake/late_time'
require './lib/mini_rake/dsl'
require 'byebug'

include MiniRake::DSL

MiniRake.application.run

# require './testfiles/tasks'
