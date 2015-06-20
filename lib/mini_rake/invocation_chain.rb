module MiniRake

  class InvocationChain

    attr_reader :head, :tail
    include Enumerable

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

    # Enumerable implementation
    def each
      curr_node = self
      while !curr_node.empty?
        yield curr_node.head
        curr_node = curr_node.tail
      end
      self
    end

    def member?(invocation)
      @head == invocation || tail.member?(invocation)
    end

    # ================================================
    # An empty chain following the Null Object Pattern
    # ================================================
    class EmptyInvocationChain < InvocationChain

      def member? invocation
        false
      end

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
