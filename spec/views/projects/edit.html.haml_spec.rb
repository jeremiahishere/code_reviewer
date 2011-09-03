require 'spec_helper'

describe "projects/edit.html.haml" do
  before(:each) do
    @project = assign(:project, stub_model(Project,
      :repo_url => "MyString",
      :default_trunk_branch => "MyString"
    ))
  end

  it "renders the edit project form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => projects_path(@project), :method => "post" do
      assert_select "input#project_repo_url", :name => "project[repo_url]"
      assert_select "input#project_default_trunk_branch", :name => "project[default_trunk_branch]"
    end
  end
end
