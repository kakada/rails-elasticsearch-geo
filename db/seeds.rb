# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
accounts = [
	{acc_number: '111456', acc_balance: '100', city: 'Phnom Penh', state: 'PP', lat: 11.5564, lon: 104.9282},
	{acc_number: '111557', acc_balance: '200', city: 'Kampong Cham', state: 'KC', lat: 12.0983, lon: 105.3131},
]

accounts.each do |acc|
	Account.create(acc) if Account.search(acc[:acc_number]).records.count <= 0
end
