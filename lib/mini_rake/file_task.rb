module MiniRake

  class FileTask < Task
    def initialize(name, deps, action)
      super(name, deps, action)
      @needs_to_invoke = true
    end

    def timestamp
      if File.exists? @name
        return File.mtime @name
      end
      MicroRake::LATE
    end

    def needed?
      !File.exists?(@name) || out_of_date?
    end

    def out_of_date?
      @deps.any? { |d| MiniRake.application[d].timestamp > timestamp }
    end
  end

end
