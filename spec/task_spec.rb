require './lib/mini_rake/task'
require './lib/mini_rake/task_manager'
require './lib/mini_rake'

describe MiniRake::Task do
  before do
    @first_task_action = spy("first_task")
    @second_task_action = spy("second_task")
    @first_task = MiniRake::Task.new("first_task", "second_task",
                                     @first_task_action)
    @second_task = MiniRake::Task.new("second_task", [],
                                      @second_task_action)
    @dummy_tasks = {}
    @dummy_tasks["first_task"] = @first_task
    @dummy_tasks["second_task"] = @second_task
  end

  describe "initialisation" do
    context "when deps is an array" do
      it 'stores the deps' do
        task = MiniRake::Task.new("some_task", ["dep1", "dep2"])
        expect(task.deps).to eq ["dep1", "dep2"]
      end
    end

    context "when the deps arg is a string" do
      it 'converts it to an array with one entry' do
        task = MiniRake::Task.new("some_task", "dep")
        expect(task.deps).to eq ["dep"]
      end
    end

    context "when deps is an empty string" do
      it 'does not store the dep' do
        task = MiniRake::Task.new("some_task", "")
        expect(task.deps.length).to eq(0)
      end
    end
  end

  describe "#execute" do
    it 'calls the given block' do
      action = spy
      task = MiniRake::Task.new("some_task", "dep", action)
      task.execute
      expect(action).to have_received(:call)
    end
  end

  describe "#needed" do
    it 'is always true' do
      expect(@first_task.needed?).to be_truthy
    end
  end

  describe "#timestamp" do
    it 'is stamped with current time' do
      @time_now = Time.now
      allow(Time).to receive(:now).and_return(@time_now)
      expect(@first_task.timestamp).to eq(Time.now)
    end
  end

  describe "invoke" do
    it 'calls the task' do
      @second_task.invoke
      expect(@second_task_action).to have_received(:call)
    end

    it "doesn't call the action a second time" do
      @second_task.invoke
      @second_task.invoke
      expect(@second_task_action).to have_received(:call).once
    end

    it 'invokes dependent tasks' do
      allow(@first_task.application).to receive(:[]) do |arg|
        @dummy_tasks[arg]
      end
      @first_task.invoke
      expect(@first_task_action).to have_received(:call)
      expect(@second_task_action).to have_received(:call)
    end
  end

end
