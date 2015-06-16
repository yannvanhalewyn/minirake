TASKS = {}

class Task
  def initialize(name, deps, action)
    @name = name
    @deps = deps
    @action = action || lambda{}
  end

  def invoke
    return if @already_invoked
    @deps.each { |dep| TASKS[dep].invoke }
    execute
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

  def invoke
    return if @already_invoked
    @deps.each do |dep|
      TASKS[dep].execute if TASKS[dep].needed?
    end
    execute if needed?
  end

  def timestamp
    if File.exists? @name
      return File.mtime @name
    end
    return Time.now - (5*365*24*60*60)
  end

  def needed?
    !File.exists? @name || out_of_date?
  end

  def out_of_date
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
  File.write filename, ""
end

def rm arg
  if arg.instance_of? Array
    arg.each do |file|
      delete_if_exists file
    end
  else
    delete_if_exists arg
  end
end

def delete_if_exists filename
  File.delete filename if File.exists? filename
end


require "./filetasks.rb"

TASKS["default"].invoke if ARGV.empty? && TASKS["default"]
ARGV.each do |arg| TASKS[arg].invoke end

