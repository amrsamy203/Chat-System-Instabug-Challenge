class AddIndexToChats < ActiveRecord::Migration[7.0]
  def change
    add_index :chats, :identifier_number
  end
end
