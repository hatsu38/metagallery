class CreateInquiries < ActiveRecord::Migration[5.1]
  def change
    create_table :inquiries do |t|
      t.string :email
      t.string :message

      t.timestamps
    end
  end
end
