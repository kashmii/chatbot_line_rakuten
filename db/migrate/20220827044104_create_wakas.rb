class CreateWakas < ActiveRecord::Migration[7.0]
  def change
    create_table :wakas do |t|
      t.string :author
      t.string :first_half
      t.string :second_half

      t.timestamps
    end
  end
end
