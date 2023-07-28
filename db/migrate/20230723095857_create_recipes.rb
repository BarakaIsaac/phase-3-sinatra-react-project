class CreateRecipes < ActiveRecord::Migration[6.1]
  def change
    create_table :recipes do |t|
      t.string :name, null: false
      t.text :ingredients, array: true
      t.text :instructions

      t.timestamps
    end
  end
end
