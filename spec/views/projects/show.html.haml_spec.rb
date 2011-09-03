require 'spec_helper'

describe "projects/show.html.haml" do
  before(:each) do
    @project = assign(:project, stub_model(Project,
      :repo_url => "Repo Url",
      :default_trunk_branch => "Default Trunk Branch"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Repo Url/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Default Trunk Branch/)
  end
end
