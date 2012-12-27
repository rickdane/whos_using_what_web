class CreatePersonSearches < ActiveRecord::Migration
  def change
    create_table :person_searches do |t|
      t.string :zipcode
      t.string :programming_language

      t.timestamps
    end
  end
end
