require './lib/mini_rake/task_manager'
require './lib/mini_rake/task'

class TaskManager
  include MiniRake::TaskManager
end

describe MiniRake::TaskManager do

  before(:each) do
    @tm = TaskManager.new
  end

  describe "#define_task" do
    let (:t) { @tm.define_task("some_task", ["dep1", "dep2"], lambda{}) }

    it 'stores a Task instance' do
      expect(t.class).to eq MiniRake::Task
    end

  end
end
