# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

10.times do
  User.create(
    email: Faker::Internet.email,
    password: "p4ssw0rd"
  )
end

users = User.all
100.times do
  task = Task.create!(
    title: Faker::Hobby.activity,
    deadline: Faker::Date.forward(days: 30),
    owner: users.sample
  )
  task.state = rand(4)
  task.completed_at = Faker::Date.forward(days: 30) if task.completed?
  task.canceled_at = Faker::Date.forward(days: 30) if task.canceled?
  task.save(validate: false)
end

Task.all.each do |task|
  rand(10).times do |n|
    approver = users.sample
    unless approver.in? task.approvers
      task.approvers << approver if approver != task.owner
    end
  end
end