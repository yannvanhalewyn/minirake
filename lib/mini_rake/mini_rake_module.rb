module MiniRake

  class << self
    def application
      @application ||= Application.new
    end
  end

end
