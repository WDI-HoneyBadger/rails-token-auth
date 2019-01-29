class CreateCups < ActiveRecord::Migration[5.2]
  def change
    create_table :cups do |t|
      t.float :capacity
      t.string :material
      t.string :color

      t.timestamps
    end
  end
end
