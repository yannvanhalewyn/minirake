module MiniRake

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

end
