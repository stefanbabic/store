class AddShipDateToOrder < ActiveRecord::Migration[5.0]
  def self.up
    add_column :orders, :ship_date, :datetime
  end

  def self.down
    remove_column :orders, :ship_date
  end
end
