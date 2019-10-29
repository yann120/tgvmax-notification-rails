class AddFieldsToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :tgvmax_key, :string
    add_column :users, :birthdate, :date
  end
end
