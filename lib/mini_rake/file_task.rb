require './lib/mini_rake/task'
require './lib/mini_rake/late_time'

module MiniRake

  class FileTask < Task
    def initialize(name, deps=[], action=lambda{})
      super(name, deps, action)
      @needs_to_invoke = true
    end

    def timestamp
      if File.exists? @name
        return File.mtime @name
      end
      MiniRake::LATE
    end

    def needed?
      !File.exists?(@name) || out_of_date?
    end

    def out_of_date?
      @deps.any? { |d| MiniRake.application[d].timestamp > timestamp }
    end
  end

end
