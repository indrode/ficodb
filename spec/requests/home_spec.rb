require 'spec_helper'

describe "Home" do
  it "GET/index works!" do
    get "home/index"
    response.status.should be(200)
  end
  
  it "should be the homepage" do
    visit root_path
    page.should have_content('Ficodb')
  end
end
