class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.string :name
      t.string :location
      t.text :url

      t.timestamps
    end
  end
end
