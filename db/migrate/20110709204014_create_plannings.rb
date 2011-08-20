class CreatePlannings < ActiveRecord::Migration
  def self.up
    create_table :plannings do |t|
      t.string :name
      t.text :description
      t.date :start_date
      t.date :end_date
      t.integer :area_id

      t.timestamps
    end
  end

  def self.down
    drop_table :plannings
  end
end
