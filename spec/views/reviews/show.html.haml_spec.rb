require 'spec_helper'

describe "reviews/show.html.haml" do
  before(:each) do
    @review = assign(:review, stub_model(Review,
      :trunk_branch => "Trunk Branch",
      :development_branch => "Development Branch",
      :closed => false,
      :submitter_id => 1,
      :project_id => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Trunk Branch/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Development Branch/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/false/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
  end
end
