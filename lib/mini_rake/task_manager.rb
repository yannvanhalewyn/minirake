require './lib/mini_rake/task'

module MiniRake

  module TaskManager

    def initialize
      @tasks = Hash.new
    end

    def define_task(name, deps, block)
      @tasks[name] = MiniRake::Task.new(name, deps, block)
    end

    def define_file_task(name, deps, block)
      @tasks[name] = MiniRake::FileTask.new(name, deps, block)
    end

    def run_tasks
      invoke_task main_task
    end

    def [](name)
      @tasks[name] || no_such_task(name)
    end

    private
    def invoke_task(task)
      task.invoke
    end

    def main_task
      if ARGV.empty?
        @tasks["default"] || @tasks.values.first
      else
        self[ARGV[0]]
      end
    end

    def no_such_task(name)
      raise "Could not find task: '#{name}'"
    end

  end

end
