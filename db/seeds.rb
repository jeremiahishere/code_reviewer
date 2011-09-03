# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

coder_role = Role.find_or_create_by_name("coder")
manager_role = Role.find_or_create_by_name("manager")
admin_role = Role.find_or_create_by_name("admin")

user = User.find_or_create_by_email("admin@codereviewer.com", :password => "jeremiahiscool", :password_confirmation => "jeremiahiscool")
user.roles = [admin_role]
user.save

