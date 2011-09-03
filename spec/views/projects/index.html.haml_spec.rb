require 'spec_helper'

describe "projects/index.html.haml" do
  before(:each) do
    assign(:projects, [
      stub_model(Project,
        :repo_url => "Repo Url",
        :default_trunk_branch => "Default Trunk Branch"
      ),
      stub_model(Project,
        :repo_url => "Repo Url",
        :default_trunk_branch => "Default Trunk Branch"
      )
    ])
  end

  it "renders a list of projects" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Repo Url".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Default Trunk Branch".to_s, :count => 2
  end
end
