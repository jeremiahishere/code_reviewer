require 'spec_helper'

describe "reviews/edit.html.haml" do
  before(:each) do
    @review = assign(:review, stub_model(Review,
      :trunk_branch => "MyString",
      :development_branch => "MyString",
      :closed => false,
      :submitter_id => 1,
      :project_id => 1
    ))
  end

  it "renders the edit review form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => reviews_path(@review), :method => "post" do
      assert_select "input#review_trunk_branch", :name => "review[trunk_branch]"
      assert_select "input#review_development_branch", :name => "review[development_branch]"
      assert_select "input#review_closed", :name => "review[closed]"
      assert_select "input#review_submitter_id", :name => "review[submitter_id]"
      assert_select "input#review_project_id", :name => "review[project_id]"
    end
  end
end
