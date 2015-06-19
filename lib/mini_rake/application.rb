module MiniRake

  class Application

    include TaskManager

    def initialize
      super
    end

    def run
      load_rake_file
      run_tasks
    end

    def load_rake_file
      load("./testfiles/filetasks.rb")
    end

  end

end
