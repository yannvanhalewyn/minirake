module MiniRake

  class InvocationChain

    attr_reader :head, :tail

    def initialize(head, tail=EMPTY)
      @head = head
      @tail = tail
    end

    def append(newHead)
      self.class.cons(newHead, self)
    end

    def self.cons(head, tail)
      new(head, tail)
    end

    def empty?
      false
    end

    # ================================================
    # An empty chain following the Null Object Pattern
    # ================================================
    class EmptyInvocationChain < InvocationChain

      def empty?
        true
      end

      def initialize
      end

      def self.cons(head, tail)
        InvocationChain.cons(head, tail)
      end


    end

    EMPTY = EmptyInvocationChain.new

  end

end
