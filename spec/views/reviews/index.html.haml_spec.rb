require 'spec_helper'

describe "reviews/index.html.haml" do
  before(:each) do
    assign(:reviews, [
      stub_model(Review,
        :trunk_branch => "Trunk Branch",
        :development_branch => "Development Branch",
        :closed => false,
        :submitter_id => 1,
        :project_id => 1
      ),
      stub_model(Review,
        :trunk_branch => "Trunk Branch",
        :development_branch => "Development Branch",
        :closed => false,
        :submitter_id => 1,
        :project_id => 1
      )
    ])
  end

  it "renders a list of reviews" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Trunk Branch".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Development Branch".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => false.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end
