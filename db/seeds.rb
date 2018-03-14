# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# puts "Seed starts..."

# uncategorized = Category.find_by(name: "Uncategorized")
# uncategorized.average = 10
# uncategorized.save

# electricity = Category.find_by(name: "Electricity" )
# electricity.average = 11.50
# electricity.save

# gas_fuel = Category.find_by(name: "Gas & Fuel" )
# gas_fuel.average = 31.9
# gas_fuel.save

# supermarket_groceries = Category.find_by(name: "Supermarkets / Groceries" )
# supermarket_groceries.average = 58
# supermarket_groceries.save

# checks = Category.find_by(name: "Checks" )
# checks.average = 2
# checks.save

# withdrawals = Category.find_by(name: "Withdrawals" )
# withdrawals.average = 105.7
# withdrawals.save

# transfer = Category.find_by(name: "Transfer" )
# transfer.average = 50
# transfer.save

# tolls = Category.find_by(name: "Tolls" )
# tolls.average = 0.01
# tolls.save

# puts "Done."

Transaction.destroy_all
Plan.destroy_all
User.destroy_all
BankAccount.destroy_all

puts "Seed starts..."
puts "User..."

user = User.create!(email: 'seeduser@test.com',
  password: '123456')

puts "Bank accounts..."

checking_account = BankAccount.create!({
bank_name: "Barclays",
account_type: "checking",
account_name: "Checking Account",
balance: 1000,
currency: "GBP",
user_id: user.id,
api_account_id: 999,
  })

saving_account = BankAccount.create!({
bank_name: "Barclays",
account_type: "saving",
account_name: "Saving Account",
balance: 5000,
currency: "GBP",
user_id: user.id,
api_account_id: 998,
  })

puts "Transactions..."

api_id_checking = 0
200.times do
  api_id_checking += 1
  Transaction.create!({
    amount: rand(-100..0),
    currency: "GBP",
    description: Faker::Job.field,
    date: Faker::Date.between(52.weeks.ago, Date.today),
    bank_account_id: checking_account.id,
    api_transaction_id: api_id_checking,
    category_id: rand(1..141),
})
end

api_id_checking += 1
Transaction.create!({
  amount: -800,
  currency: "GBP",
  description: "Holiday",
  date: Date.today - 10.weeks,
  bank_account_id: checking_account.id,
  api_transaction_id: api_id_checking,
  category_id: 36,
})

month_counter = 13
api_id_saving = 300
12.times do
  month_counter -= 1
  api_id_saving += 1
  Transaction.create!({
    amount: 1000,
    currency: "GBP",
    description: "Salary",
    date: (Date.today - month_counter.months),
    bank_account_id: saving_account.id,
    api_transaction_id: api_id_saving,
    category_id: 11,
})
end

api_id_saving += 1
Transaction.create!({
    amount: 3500,
    currency: "GBP",
    description: "Bonus",
    date: (Date.today - 3.months),
    bank_account_id: saving_account.id,
    api_transaction_id: api_id_saving,
    category_id: 11,
})

puts "Plan..."

Plan.create!({
  target_year: 2019,
  target_amount: 12000,
  weekly_savings_target: 200,
  user_id: user.id,
})

  puts "Done."














