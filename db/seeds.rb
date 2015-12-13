# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

create_array = []
(0...96234).each do |i|
  create_array << {category_id: i % 10, title: "#{i}番目", description: "#{i}番目の説明"}
end

Record.create(create_array)
