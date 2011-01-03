class CreateTransactions < ActiveRecord::Migration
  def self.up
    create_table :transactions do |t|
      t.date :date, :null => false
      t.string :description
      t.float :value, :null => false
      t.float :amount
      t.references :category, :null => false

      t.timestamps
    end
    execute <<-SQL
      ALTER TABLE transactions
        ADD CONSTRAINT fk_transactions_categories
        FOREIGN KEY (category_id)
        REFERENCES categories(id)
    SQL
  end

  def self.down
    drop_table :transactions
  end
end
