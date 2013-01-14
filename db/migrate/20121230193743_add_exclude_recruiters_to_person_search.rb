class AddExcludeRecruitersToPersonSearch < ActiveRecord::Migration
  def change
    begin
      add_column :person_searches, :fieldname, :boolean
    rescue
    end
  end
end
