require './lib/mini_rake/late_time.rb'

describe MiniRake::LateTime do

  it "Is later than current time" do
    late = MiniRake::LateTime.instance
    expect(late).to be > Time.now
    expect(Time.now).to be < late
  end

  it "Equals (==) itself" do
    late = MiniRake::LateTime.instance
    expect(late).to eq(late)
  end

  it "Didn't mess up existing time tests" do
    later = Time.now + 100
    expect(later).to be > Time.now
  end

end

