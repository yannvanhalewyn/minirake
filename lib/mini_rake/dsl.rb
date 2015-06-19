module MiniRake

  module DSL
    def task(name, deps=[], &block)
      MiniRake.application.define_task(name, deps, block)
    end

    def file(name, deps=[], &block)
      MiniRake.application.define_file_task(name, deps, block)
    end
  end

end
