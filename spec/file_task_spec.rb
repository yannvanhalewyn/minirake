require './lib/mini_rake/file_task'
require './lib/mini_rake'
require 'fakefs/spec_helpers'

describe MiniRake::FileTask do


  describe "#timestamp()" do
    context "when the target file doesn't exist" do
      it 'returns an instance of LateTime' do
        task = MiniRake::FileTask.new("UnexistingFile.txt")
        expect(task.timestamp).to equal(MiniRake::LateTime.instance)
      end
    end

    context "when the target file exists" do
      include FakeFS::SpecHelpers
      it 'returns the timestamp of that file' do
        task = MiniRake::FileTask.new("existingfile.txt")
        FileUtils.touch "existingfile.txt"
        expect(task.timestamp).to eq(File.mtime "existingfile.txt")
      end
    end
  end

  describe "#needed()" do
    context "when target file doesn't exist" do
      it 'returns true' do
        task = MiniRake::FileTask.new("inexistant.txt")
        expect(task.needed?).to be_truthy
      end
    end

    context "when target file exists" do
      include FakeFS::SpecHelpers
      context "and there are no deps" do
        it 'returns false' do
          FileUtils.touch "existingfile.txt"
          task = MiniRake::FileTask.new("existingfile.txt")
          expect(task.needed?).to be_falsey
        end
      end

      context "and all deps are anterior" do
        it 'returns false' do
          FileUtils.touch "dep.txt"
          FileUtils.touch "dep2.txt"
          FileUtils.touch "target.txt"
          task = MiniRake::FileTask.new("target.txt", "dep.txt", "dep2.txt")
          expect(task.needed?).to be_falsey
        end
      end

      context "when one dep is posterior" do
        it 'returns true' do
          FileUtils.touch "dep.txt"
          FileUtils.touch "target.txt"
          FileUtils.touch "dep2.txt"
          task = MiniRake::FileTask.new("target.txt",
                                        ["dep.txt", "dep2.txt"])
          expect(task.needed?).to be_truthy
        end
      end
    end
  end

end
