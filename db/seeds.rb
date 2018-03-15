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
PlanAccount.destroy_all
Plan.destroy_all
User.destroy_all
Category.destroy_all
BankAccount.destroy_all

puts "Seed starts..."
puts "User..."

user = User.create!(email: 'vincent@gmail.com',
  password: '123456')

puts "Bank accounts..."

checking_account = BankAccount.create!({
bank_name: "HSBC",
account_type: "checking",
account_name: "Current",
balance: 1000,
currency: "GBP",
user_id: user.id,
api_account_id: 999,
  })

saving_account = BankAccount.create!({
bank_name: "HSBC",
account_type: "saving",
account_name: "Savings",
balance: 5000,
currency: "GBP",
user_id: user.id,
api_account_id: 998,
  })

puts "Categories"

income_cat_1 = Category.create!({
  api_category_id: 441890,
  name: "Salaries",
  parent_id: 166,
  average: 510
})

income_cat_2 = Category.create!({
  api_category_id: 78,
  name: "Transfer",
  parent_id: 303
})

spending_cat_1 = Category.create!({
  api_category_id: 314,
  name: "Rent",
  parent_id: 2,
  average: 33
})

spending_cat_2 = Category.create!({
  api_category_id: 302,
  name: "Taxes",
  parent_id: 159,
  average: 137
})


spending_cat_3 = Category.create!({
  api_category_id: 273,
  name: "Supermarkets / Groceries",
  parent_id: 168,
  average: 58
})

spending_cat_4 = Category.create!({
  api_category_id: 226,
  name: "Hobbies",
  parent_id: 170,
  average: 6
})

spending_cat_5 = Category.create!({
  api_category_id: 87,
  name: "Gas & Fuel",
  parent_id: 165,
  average: 20
})


spending_cat_6 = Category.create!({
  api_category_id: 85,
  name: "Withdrawals",
  parent_id: 303,
  average: 40
})


spending_cat_7 = Category.create!({
  api_category_id: 83,
  name: "Restaurants",
  parent_id: 168,
  average: 39
})

spending_cat_8 = Category.create!({
  api_category_id: 171,
  name: "Bills & Utilities",
  average: 31
})

spending_cat_9 = Category.create!({
  api_category_id: 180,
  name: "Internet",
  parent_id: 171,
  average: 4
})

spending_cat_10 = Category.create!({
  api_category_id: 276,
  name: "Other spending",
  parent_id: 160,
  average: 83
})

spendings = [spending_cat_1, spending_cat_2 , spending_cat_3, spending_cat_4, spending_cat_5, spending_cat_6, spending_cat_7, spending_cat_8, spending_cat_9, spending_cat_10]
incomes = [income_cat_1, income_cat_2]

puts "Transactions..."


api_id_checking = 0
200.times do
  api_id_checking += 1
  Transaction.create!({
    amount: rand(-150..-1),
    currency: "GBP",
    description: Faker::Job.field,
    date: Faker::Date.between(52.weeks.ago, Date.today),
    bank_account_id: checking_account.id,
    api_transaction_id: api_id_checking,
    category: spendings.sample
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
  category: spending_cat_10,
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
    category: income_cat_1,
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
    category: income_cat_1,
})

puts "Plan..."

Plan.create!({
  target_year: 10,
  target_amount: 12000,
  weekly_savings_target: 200,
  user_id: user.id,
  name: "House Deposit"
  # created_at = Date.today - 300 # To set the date of the plan in the past
})

  puts "Done."














