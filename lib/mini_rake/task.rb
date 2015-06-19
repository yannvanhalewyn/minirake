module MiniRake

  class Task
    def initialize(name, deps, action=lambda{})
      @name = name
      @deps = Array deps
      @action = action
    end

    def application
      MiniRake.application
    end

    def invoke
      return if @already_invoked
      @deps.each do |dep|
        application[dep].invoke
      end
      execute if needed?
      @already_invoked = true
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
  end

end
