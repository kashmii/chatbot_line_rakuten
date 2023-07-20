class CreateFirstParts < ActiveRecord::Migration[7.0]
  def change
    create_table :first_parts do |t|
      t.string :content

      t.timestamps
    end

    create_table :second_parts do |t|
      t.string :content

      t.timestamps
    end

    create_table :authors do |t|
      t.string :name

      t.timestamps
    end
  end
end
