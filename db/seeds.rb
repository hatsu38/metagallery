# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require "csv"

csv_file = "db/service.csv"

CSV.foreach(csv_file,headers: true) do |data|
  Service.create(
    name: data[0],
    url: data[1],
    domain: data[10],
    title: data[9],
    description: data[5],
    favicon: data[2],
    ogpimg: data[6],
    ogpdescription: data[8]
  )
end

keyword_service_file = "db/keyword_service.csv"


CSV.foreach(keyword_service_file,headers: true) do |data|
  word = Keyword.create(
    name: data[0]
  )
  ServiceKeyword.create(service_id: data[1],keyword_id: word.id) if data[1]
  ServiceKeyword.create(service_id: data[2],keyword_id: word.id) if data[2]
  ServiceKeyword.create(service_id: data[3],keyword_id: word.id) if data[3]
end



