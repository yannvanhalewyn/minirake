require 'singleton'

module MiniRake

  class LateTime
    include Comparable
    include Singleton

    def <=>(other)
      return 1
    end
  end

  LATE = LateTime.instance

end
