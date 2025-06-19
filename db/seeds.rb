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
# Invoice.destroy_all
# ProjectDate.destroy_all
# Project.destroy_all
# Client.destroy_all
# User.destroy_all

# # Users
# users = 5.times.map do |i|
#   User.create!(
#     email: "freelancer#{i}@example.com",
#     password: "password#{i}",
#     first_name: "User#{i}",
#     last_name: "Last#{i}",
#     date_of_birth: Date.new(1990, 1, i+1),
#     address: "#{i+1} Main St",
#     phone_number: "123456789#{i}"
#   )
# end

# # Clients
# clients = 5.times.map do |i|
#   Client.create!(
#     first_name: "Client#{i}",
#     last_name: "Surname#{i}",
#     date_of_birth: Date.new(1985, 5, i+1),
#     address: "#{i+10} Client Ave",
#     phone_number: "98765432#{100 + i}",
#     company_name: "Company#{i}",
#     email: "client#{i}@company.com"
#   )
# end

# # Projects
# projects = 5.times.map do |i|
#   Project.create!(
#     name: "Project #{i}",
#     price: (1000 * (i+1)),
#     status: [true, false].sample,
#     user: users[i],
#     client: clients[i],
#     created_at: Time.now - (i * 5).days,
#     updated_at: Time.now - (i * 2).days
#   )
# end

# # Project Dates
# project_dates = 5.times.map do |i|
#   ProjectDate.create!(
#     start_date: Date.today - (i * 10),
#     end_date: Date.today + (i * 10),
#     project: projects[i],
#     created_at: Time.now - (i * 5).days,
#     updated_at: Time.now - (i * 2).days
#   )
# end

# # Invoices
# 5.times do |i|
#   Invoice.create!(
#     tax: 0.18 + i * 0.01,
#     description: "Invoice #{i} for #{projects[i].name}",
#     project: projects[i],
#     created_at: Time.now - (i * 5).days,
#     updated_at: Time.now - (i * 2).days
#   )
# end

# puts "Seeded 5 users, clients, projects, project_dates, and invoices!"


require 'faker'
# Fetch your existing user
user = User.find_by!(email: 'roger.tsikata@gmail.com')
# Helper: Random timestamp in the past 120 days
def random_past_datetime
  Faker::Time.backward(days: rand(30..120), period: :morning)
end
# STEP 1: Create 10 Clients
clients = 10.times.map do
  time = random_past_datetime
  Client.create!(
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    date_of_birth: Faker::Date.birthday(min_age: 25, max_age: 60),
    address: Faker::Address.full_address,
    phone_number: Faker::PhoneNumber.cell_phone_in_e164,
    company_name: Faker::Company.name,
    email: Faker::Internet.email,
    user: user,
    created_at: time,
    updated_at: time
  )
end
# STEP 2: Create 15 Projects with valid ProjectDates
projects = 15.times.map do
  client = clients.sample
  created_at = random_past_datetime
  project = Project.create!(
    name: "#{Faker::App.name} Project",
    price: rand(1000..10000),
    status: [true, false].sample,
    client: client,
    created_at: created_at,
    updated_at: created_at
  )
  # Add mandatory ProjectDate
  start_date = (created_at.to_date - rand(10..40))
  end_date = (start_date + rand(10..60))
  ProjectDate.create!(
    start_date: start_date,
    end_date: end_date,
    project: project,
    created_at: created_at,
    updated_at: created_at
  )
  project
end
# STEP 3: Create 30 Invoices (only if project has project_date)
30.times do
  project = projects.sample
  # Defensive check: only proceed if project_date exists
  next unless project.project_date
  created_at = random_past_datetime
  amount = rand(500.0..8000.0).round(2)
  Invoice.create!(
    tax: 0.19,
    description: Faker::Commerce.product_name,
    project: project,
    status: [true, false].sample,
    performance_amount: amount,
    price_cents: (amount * 100).to_i,
    checkout_session_id: "sess_#{SecureRandom.hex(8)}",
    created_at: created_at,
    updated_at: created_at
  )
end
puts ":white_check_mark: Seeded: 10 clients, 15 projects (with project_dates), 30 invoices created (all tied to valid projects)."
