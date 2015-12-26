require 'good'

describe "Good api" do
  before(:each) do
    Good.all.destroy
  end

  it "should add a good" do
    good = Good.new
    good.name = "flour"
    good.unit = "kg"
    good.unit_size = 1
    good.price_per_unit = 1000

    expect(good.save).to be_truthy
  end
end
