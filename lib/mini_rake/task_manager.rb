module MiniRake

  module TaskManager

    def initialize
      @tasks = Hash.new
    end

    def define_task(name, deps, block)
      @tasks[name] = MiniRake::Task.new(name, deps, block)
    end

    def invoke_task(task)
      task.deps.each do |dep|
        invoke_task @tasks[dep]
      end
      task.invoke
    end

    def run_tasks
      invoke_task main_task
    end

    def main_task
      if ARGV.empty?
        @tasks["default"] || @tasks[0]
      else
        @tasks[ARGV[0]] || no_such_task(ARGV[0])
      end
    end

    def no_such_task(name)
      puts "Could not find task #{name.chomp}"
      exit(1)
    end

  end

end
