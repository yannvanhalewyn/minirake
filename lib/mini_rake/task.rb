module MiniRake

  class Task
    def initialize(name, deps, action)
      @name = name
      @deps = deps
      @action = action || lambda{}
    end

    def invoke
      return if @already_invoked
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
