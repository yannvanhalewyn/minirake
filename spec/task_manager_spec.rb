require './lib/mini_rake/task_manager'

class TaskManager
  include MiniRake::TaskManager
end

describe MiniRake::TaskManager do

  describe "#define_task()" do
    it 'stores a Task instance' do
      tm = TaskManager.new
      task = tm.define_task("some_task", ["dep1", "dep2"], lambda{})
      expect(task.class).to eq MiniRake::Task
      expect(task.name).to eq("some_task")
      expect(task.deps).to eq(["dep1", "dep2"])
    end
  end

  describe "#run_tasks()" do
    before(:each) do
      @tm = TaskManager.new
      @task1 = @tm.define_task("first_task", ["second_task", "third_task"], nil)
      allow(@task1).to receive(:invoke)
      @task2 = @tm.define_task("second_task", nil, nil)
      allow(@task2).to receive(:invoke)
      @task3 = @tm.define_task("third_task", nil, nil)
      allow(@task3).to receive(:invoke)
    end

    context "when no ARGS are given" do
      before(:each) { ARGV.replace [] }
      context "when no default task is given" do
        it 'runs the first defined task' do
          @tm.run_tasks
          expect(@task1).to have_received(:invoke)
        end
      end

      context "when a default task is given" do
        it 'runs the default task' do
          @default_task = @tm.define_task("default", nil, nil)
          allow(@default_task).to receive(:invoke)
          @tm.run_tasks
          expect(@default_task).to have_received(:invoke)
        end
      end
    end

    context "When ARG given" do
      before(:each) { ARGV.replace ["second_task"] }
      context "when no default task is given" do
        it 'runs the task specified by the ARG' do
          @tm.run_tasks
          expect(@task2).to have_received(:invoke)
        end
      end

      context "when a default task is given" do
        it 'runs the task specified by the ARG' do
          @default_task = @tm.define_task("default", nil, nil)
          allow(@default_task).to receive(:invoke)
          @tm.run_tasks
          expect(@task2).to have_received(:invoke)
          expect(@default_task).not_to have_received(:invoke)
        end
      end
    end

    describe "#[]()" do
      before(:each) do
        @tm = TaskManager.new
        @task1 = @tm.define_task("first_task", ["second_task", "third_task"], nil)
      end

      it "returns the task object if exists" do
        expect(@tm["first_task"]).to equal(@task1)
      end

      it "throws when no such task has been found" do
        expect{@tm["unknown"]}.to raise_error("Could not find task: 'unknown'")
      end
    end
  end
end
