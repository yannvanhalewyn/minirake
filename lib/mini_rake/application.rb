module MiniRake

  class Application

    include TaskManager

    def initialize
      super
    end

    def run
      load_rake_file
      # @tasks["default"].invoke if ARGV.empty? && TASKS["default"]
      # ARGV.each do |arg| TASKS[arg].invoke end
    end

    def load_rake_file
      load("./testfiles/tasks.rb")
    end

  end

end
