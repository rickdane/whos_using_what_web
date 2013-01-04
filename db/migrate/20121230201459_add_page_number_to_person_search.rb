class AddPageNumberToPersonSearch < ActiveRecord::Migration
  def change
    add_column :person_searches, :page_number, :string
  end
end
