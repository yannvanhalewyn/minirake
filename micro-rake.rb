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
end

def task(name, deps=[], &block)
  TASKS[name] = Task.new(name, deps, block)
end

require "./tasks"

TASKS["default"].invoke if ARGV.empty? && TASKS["default"]
ARGV.each do |arg| TASKS[arg].invoke end
