class AddIndexToMessages < ActiveRecord::Migration[7.0]
  def change
    add_index :messages, :identifier_number
  end
end
