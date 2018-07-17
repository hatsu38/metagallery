class CreateServices < ActiveRecord::Migration[5.1]
  def change
    create_table :services do |t|
      t.string :name
      t.string :url
      t.string :domain
      t.string :title
      t.text :description
      t.string :favicon
      t.string :ogpimg
      t.text :ogpdescription

      t.timestamps
    end
  end
end
