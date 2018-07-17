class CreateServiceKeywords < ActiveRecord::Migration[5.1]
  def change
    create_table :service_keywords do |t|
      t.references :service, foreign_key: true
      t.references :keyword, foreign_key: true

      t.timestamps
    end
  end
end
