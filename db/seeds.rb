# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Authuser.delete_all

Authuser.create! ([
  {id: 1, name: "P Natarajan", email: "natarajan.perumalsamy@gmail.com", password: "abcdefgh", approved: true}
  ])

#Authuser.create(name: "P Natarajan", email: "natarajan.perumalsamy@gmail.com", password: "abcdefgh", approved: true)
#Membership.create(authuser_id: 1, phone_number: "1234567890", membership_satrt_date: Date.today, membership_end_date: Date.today+1.year)
#Address.create(authuser_id: 1, address_line_1: "PG Pudur, Pollachi", city: "CBE", state: "TN", country: "India")
#Permission.create(authuser_id: 1, main_role_id:  1.to_i)

