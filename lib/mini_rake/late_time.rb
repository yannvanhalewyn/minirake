require 'singleton'

module MicroRake

  class LateTime
    include Comparable
    include Singleton

    def <=>(other)
      return 1
    end
  end

  LATE = LateTime.instance
end
