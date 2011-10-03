require 'spec_helper'

describe "Home" do
  it "GET/index works!" do
    get "home/index"
    response.status.should be(200)
  end
end
