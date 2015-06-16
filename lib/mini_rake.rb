$LOAD_PATH << "lib"
require 'singleton'
require 'mini_rake/late_time'

TASKS = {}

class Task
  def initialize(name, deps, action)
    @name = name
    @deps = deps
    @action = action || lambda{}
  end

  def invoke
    return if @already_invoked
    @deps.each do |dep|
      # puts "dep: #{dep} - needed: #{TASKS[dep].needed?}"
      TASKS[dep].invoke if TASKS[dep].needed?
    end
    execute if needed?
    @already_invoked = true
  end

  def execute
    @action.call
  end

  def needed?
    true
  end

  def timestamp
    Time.now
  end
end

class FileTask < Task
  def initialize(name, deps, action)
    super(name, deps, action)
    @needs_to_invoke = true
  end

  def timestamp
    if File.exists? @name
      return File.mtime @name
    end
    MicroRake::LATE
  end

  def needed?
    !File.exists?(@name) || out_of_date?
  end

  def out_of_date?
    @deps.any? { |d| TASKS[d].timestamp > timestamp }
  end
end

def task(name, deps=[], &block)
  TASKS[name] = Task.new(name, deps, block)
end

def file(name, deps=[], &block)
  TASKS[name] = FileTask.new(name, deps, block)
end

def touch filename
  puts "touch #{filename}"
  File.write filename, ""
end

def rm arg
  if arg.instance_of? Array
    arg.each do |file|
      puts "rm #{file}"
      delete_if_exists file
    end
  else
    puts "rm #{arg}"
    delete_if_exists arg
  end
end

def delete_if_exists filename
  File.delete filename if File.exists? filename
end


require "./testfiles/filetasks.rb"

TASKS["default"].invoke if ARGV.empty? && TASKS["default"]
ARGV.each do |arg| TASKS[arg].invoke end

