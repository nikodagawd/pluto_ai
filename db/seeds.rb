# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

user = User.find_or_create_by!(email: "dev@example.com") do |u|
  u.username = "pluto"
  u.password = "password"
  u.password_confirmation = "password"
end

require 'json'

seed_file = Rails.root.join('db', 'seed_companies.json')
companies_data = JSON.parse(File.read(seed_file), symbolize_names: true)

puts "Seeding #{companies_data.size} companies..."

companies_data.each_with_index do |company_attrs, i|
  Company.find_or_create_by!(company_name: company_attrs[:company_name]) do |company|
    company.assign_attributes(company_attrs)
  end
  print "\r  [#{i + 1}/#{companies_data.size}]" if (i + 1) % 500 == 0 || i + 1 == companies_data.size
end

puts "\nCreated #{Company.count} companies!"
