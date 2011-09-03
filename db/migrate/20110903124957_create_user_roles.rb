class CreateUserRoles < ActiveRecord::Migration
  def self.up
    create_table(:roles) do |t|
      t.string :name
      
      t.timestamps
    end 

    create_table(:assignments) do |t|
      t.integer :role_id 
      t.integer :user_id 

      t.timestamps
    end
  end

  def self.down
    drop_table :roles
    drop_table :timestamps
  end
end
