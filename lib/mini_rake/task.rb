require './lib/mini_rake/invocation_chain'

module MiniRake

  class Task

    attr_reader :name, :deps

    def initialize(name, deps, action=lambda{})
      @already_invoked = false
      @name = name
      @deps = []
      @deps = Array deps unless (!deps || deps.empty?)
      @action = action || lambda{}
    end

    def invoke(chain=InvocationChain::EMPTY)
      return if @already_invoked
      save_from_circular_dependencies(chain) do
        @deps.each do |dep|
          application[dep].invoke chain.append(self)
        end
      end
      execute if needed?
      @already_invoked = true
    end

    def save_from_circular_dependencies(chain)
      raise_circular_dependency_error(chain) if chain.member? self
      yield
    end

    def raise_circular_dependency_error(chain)
      all_invocations_in_order = chain.append(self).map{|c|c.name}.reverse
      raise "Circular dependencies: #{all_invocations_in_order.join(' => ')}"
    end

    def application
      MiniRake.application
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
