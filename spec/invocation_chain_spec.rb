require './lib/mini_rake/invocation_chain'

describe MiniRake::InvocationChain do

  before(:each) do
    @first_node = MiniRake::InvocationChain.new("first_node")
    @second_node = MiniRake::InvocationChain.new("second_node", @first_node)
  end
  describe "initialisation" do
    it 'stores the val as head' do
      expect(@first_node.head).to eq("first_node")
    end

    it 'stores a ref to the previous node' do
      expect(@second_node.tail).to equal(@first_node)
    end

    context "when no tail is given" do
      it 'stores an instance of EmptyInvocationChain' do
        expect(@first_node.tail.class).to eq(MiniRake::InvocationChain::EmptyInvocationChain)
      end
    end
  end

  describe ".cons()" do
    let(:cons_node) { MiniRake::InvocationChain.cons("cons", @first_node) }
    it 'returns an new InvocationChain instance' do
      expect(cons_node.class).to equal(MiniRake::InvocationChain)
    end

    it 'stores the tail' do
      expect(cons_node.tail).to equal(@first_node)
    end

    it 'stores the new head' do
      expect(cons_node.head).to eq("cons")
    end
  end

  describe "#append()" do
    let(:appended_node) { @first_node.append("appended") }

    it 'returns a new instance' do
      expect(appended_node).to_not eq(@first_node)
    end

    it 'returns an instance of the InvocationChain class' do
      expect(appended_node.class).to equal(MiniRake::InvocationChain)
    end

    it 'tails the previouse node' do
      expect(appended_node.tail).to eq(@first_node)
    end

    it 'stores the new head' do
      expect(appended_node.head).to eq("appended")
    end
  end

  describe "#empty?()" do
    it 'is false' do
      expect(@first_node.empty?).to be_falsey
    end
  end
end

describe MiniRake::InvocationChain::EmptyInvocationChain do

  let(:empty_chain) { MiniRake::InvocationChain::EMPTY }

  describe "Empty?" do
    it 'is false' do
      expect(empty_chain.empty?).to be_truthy
    end
  end

  describe "#append()" do
    let(:appended_node) { empty_chain.append("appended") }

    it 'returns a new instance of InvocationChain' do
      expect(appended_node.class).to equal(MiniRake::InvocationChain)
    end

    it 'has THE empty node as tail' do
      expect(appended_node.tail).to equal(empty_chain)
    end

    it 'stores a new head' do
      expect(appended_node.head).to eq("appended")
    end
  end
end
