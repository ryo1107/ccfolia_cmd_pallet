class CreateCmdPallets < ActiveRecord::Migration[5.2]
  def change
    create_table :cmd_pallets do |t|
      t.string :ccfolia_url

      t.timestamps
    end
  end
end
