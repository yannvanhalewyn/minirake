module MiniRake

  class Task
    def initialize(name, deps, action=lambda{})
      @already_invoked = false
      @name = name
      @deps = []
      @deps = Array deps unless (!deps || deps.empty?)
      @action = action || lambda{}
    end

    def application
      MiniRake.application
    end

    def invoke
      return if @already_invoked
      save_from_circular_dependencies do
        @deps.each do |dep|
          @name_of_last_dep_invoked = dep
          application[dep].invoke
        end
        execute if needed?
        @already_invoked = true
      end
    end

    def save_from_circular_dependencies
      raise_circular_dependency_error if @being_invoked
      @being_invoked = true
      yield
      @being_invoked = false
    end

    def raise_circular_dependency_error
      invocationChain = [@name]
      previous_task = self
      loop do
        next_task_name = previous_task.instance_exec(self){
          @name_of_last_dep_invoked }
        invocationChain << next_task_name
        previous_task = application[next_task_name]
        break if next_task_name == @name
      end
      raise "Circular dependencies: #{invocationChain.join(' => ')}"
    end

    def deps
      @deps
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

    def inspect
      "#{self.class} '#{@name}' - deps: #{@deps.join(", ")}"
    end
  end

end
