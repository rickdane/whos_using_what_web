class AddExcludeRecruitersToPersonSearch < ActiveRecord::Migration
  def change
    add_column :person_searches, :boolean
  end
end
