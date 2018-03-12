# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

puts "Seed starts..."

uncategorized = Category.find_by(name: "Uncategorized")
uncategorized.average = 10
uncategorized.save

electricity = Category.find_by(name: "Electricity" )
electricity.average = 11.50
electricity.save

gas_fuel = Category.find_by(name: "Gas & Fuel" )
gas_fuel.average = 31.9
gas_fuel.save

supermarket_groceries = Category.find_by(name: "Supermarkets / Groceries" )
supermarket_groceries.average = 58
supermarket_groceries.save

checks = Category.find_by(name: "Checks" )
checks.average = 2
checks.save

withdrawals = Category.find_by(name: "Withdrawals" )
withdrawals.average = 105.7
withdrawals.save

transfer = Category.find_by(name: "Transfer" )
transfer.average = 50
transfer.save

tolls = Category.find_by(name: "Tolls" )
tolls.average = 0.01
tolls.save

puts "Done."


