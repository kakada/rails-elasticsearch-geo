class CreateAccounts < ActiveRecord::Migration[5.2]
  def change
    create_table :accounts do |t|
      t.string :acc_number
      t.float :acc_balance
      t.string :city
      t.string :state
      t.float :lat
      t.float :lon

      t.timestamps
    end
  end
end
