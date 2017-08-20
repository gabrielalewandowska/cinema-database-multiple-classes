require_relative("../db/sql_runner")
require_relative("customer")
require_relative("ticket")

class Film

  attr_accessor(:title, :price)
  attr_reader(:id)

  def initialize(params)
    @id = params["id"].to_i
    @title = params["title"]
    @price = params["price"]
  end

  def save
    sql = "INSERT INTO films
    (title, price)
    VALUES ($1, $2)
    RETURNING id"

    values = [@title, @price]
    film = SqlRunner.run(sql, values).first
    @id = film["id"].to_i
  end

  def self.delete_all()
    sql = "DELETE FROM films"
    values = []
    SqlRunner.run(sql, values)
  end

  def self.all
    sql = "SELECT * FROM films"
    films = SqlRunner.run(sql)
    return Film.map_items(films)
  end

  def update
    sql = "UPDATE films SET (title, price) = ($1, $2)
    WHERE id = $3;"
    values = [@title, @price, @id]
    SqlRunner.run(sql, values)
  end

  def delete
    sql = "DELETE FROM films WHERE id = $1;"
    value = [@id]
    SqlRunner.run(sql, value)
  end

  def customers
    sql = "SELECT customers.* FROM customers
    INNER JOIN tickets
    ON tickets.customer_id = customers.id
    WHERE film_id = $1;"

    value = [@id]
    customers = SqlRunner.run(sql, value)
    return customers.map {|customer| Customer.new(customer)}
  end

  def how_many_customers
    results = self.customers
    return results.count
  end

  def screenings
    sql = "SELECT * FROM screenings WHERE film_id = $1;"
    value = [@id]
    screenings_array = SqlRunner.run(sql, value)
    screenngs_objects = screenings_array.map {|object| Screening.new(object)}
  end

  # def most_popular_time
  #  screenings = self.screenings
  #  tickets = []
  #  screenings.map {|film| tickets.push(film.available_tickets)}
  #  most_booked = tickets.min
  #  return most_booked
  # end

  def self.map_items(rows)
    return rows.map { |row| Film.new(row)}
  end
end
