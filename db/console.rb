require_relative("../models/customer")
require_relative("../models/film")
require_relative("../models/ticket")
require_relative("../models/screening")

require( 'pry-byebug' )

Ticket.delete_all
Customer.delete_all
Film.delete_all

customer1 = Customer.new({"name" => "Gaby", "funds" => 100})
customer1.save

customer2 = Customer.new({"name" => "Steve", "funds" => 35})
customer2.save

film1 = Film.new({"title" => "Dunkirk", "price" => 15})
film1.save

film2 = Film.new({"title" => "Hobbit", "price" => 20})
film2.save

ticket1 = Ticket.new({"customer_id" => customer1.id, "film_id" => film1.id})
ticket1.save

ticket2 = Ticket.new({"customer_id" => customer2.id, "film_id" => film2.id})
ticket2.save

screening1 = Screening.new({"film_id" => film1.id, "show_time" => "10:00", "film_price" => film1.price})
screening1.save

screening2 = Screening.new({"film_id" => film1.id, "show_time" => "12:00", "film_price" => film1.price})
screening2.save

screening3 = Screening.new({"film_id" => film1.id, "show_time" => "15:00", "film_price" => film1.price})
screening3.save





binding.pry
nil
