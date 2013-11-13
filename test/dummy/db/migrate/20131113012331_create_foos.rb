class CreateFoos < ActiveRecord::Migration
  def change
    create_table :foos do |t|
      t.references :bar, index: true

      t.timestamps
    end
  end
end
