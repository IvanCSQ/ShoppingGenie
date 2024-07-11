# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

require 'date'

User.create!(email:'kal@test.com', password:'123abc')

Expense.create!(user: User.last, date: Date.today, amount: 20.80, establishment: "Louisa Coffee", category: "Food & Drinks", items: {
  'Orange Latte': '$7.80',
  'Americano': '$4.50',
  'Pecan Pie': '$8.50'
}, tags: ['coffee', 'cafe'])

Expense.create!(user: User.last, date: Date.today, amount: 99.50, establishment: "Tong Xin Ru Yi Hotpot", category: "Food & Drinks", items: {
  'Golden Chicken Soup': '$15',
  'Mutton Ribs': '$24.50',
  'Beef Slices': '$12.90',
  'Potato Strips': '$8.90',
  'Spinach': '$6.90',
  'Fish Slices': '$14.80',
  'Service Charge': '$8.30',
  'GST': '$8.20'
}, tags: ['dinner', 'friends'])
