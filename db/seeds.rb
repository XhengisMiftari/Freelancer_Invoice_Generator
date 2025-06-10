# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
# Destroy all records to avoid duplication (for development/testing)
Invoice.destroy_all
ProjectDate.destroy_all
Project.destroy_all
Client.destroy_all
User.destroy_all

# Users
users = 5.times.map do |i|
  User.create!(
    email: "freelancer#{i}@example.com",
    password: "password#{i}",
    first_name: "User#{i}",
    last_name: "Last#{i}",
    date_of_birth: Date.new(1990, 1, i+1),
    address: "#{i+1} Main St",
    phone_number: "123456789#{i}"
  )
end

# Clients
clients = 5.times.map do |i|
  Client.create!(
    first_name: "Client#{i}",
    last_name: "Surname#{i}",
    date_of_birth: Date.new(1985, 5, i+1),
    address: "#{i+10} Client Ave",
    phone_number: "98765432#{100 + i}",
    company_name: "Company#{i}",
    email: "client#{i}@company.com"
  )
end

# Projects
projects = 5.times.map do |i|
  Project.create!(
    name: "Project #{i}",
    price: (1000 * (i+1)),
    status: [true, false].sample,
    user: users[i],
    client: clients[i],
    created_at: Time.now - (i * 5).days,
    updated_at: Time.now - (i * 2).days
  )
end

# Project Dates
project_dates = 5.times.map do |i|
  ProjectDate.create!(
    start_date: Date.today - (i * 10),
    end_date: Date.today + (i * 10),
    project: projects[i],
    created_at: Time.now - (i * 5).days,
    updated_at: Time.now - (i * 2).days
  )
end

# Invoices
5.times do |i|
  Invoice.create!(
    tax: 0.18 + i * 0.01,
    description: "Invoice #{i} for #{projects[i].name}",
    project: projects[i],
    created_at: Time.now - (i * 5).days,
    updated_at: Time.now - (i * 2).days
  )
end

puts "Seeded 5 users, clients, projects, project_dates, and invoices!"
