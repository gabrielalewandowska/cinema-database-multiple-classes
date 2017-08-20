require_relative("../db/sql_runner")
require_relative("film")
require_relative("ticket")

class Customer

  attr_accessor(:name, :funds)
  attr_reader(:id)

  def initialize(params)
    @id = params["id"].to_i
    @name = params["name"]
    @funds = params["funds"]
  end

  def save
    sql = "INSERT INTO customers
    (name, funds)
    VALUES
    ($1, $2)
    RETURNING ID;
    "

    values = [@name, @funds]
    customer = SqlRunner.run(sql, values).first
    @id = customer["id"].to_i
  end

  def self.delete_all()
    sql = "DELETE FROM customers;"
    values = []
    SqlRunner.run(sql, values)
  end

  def self.all
    sql = "SELECT * FROM customers;"
    customers = SqlRunner.run(sql)
    return Customer.map_items(customers)
  end

  def update
    sql = "UPDATE customers SET (name, funds) = ($1, $2)
    WHERE id = $3;"
    values = [@name, @funds, @id]
    SqlRunner.run(sql, values)
  end

  def delete
    sql = "DELETE FROM customers WHERE id = $1;"
    value = [@id]
    SqlRunner.run(sql, value)
  end

  def films
    sql = "SELECT films.* FROM films
    INNER JOIN tickets
    ON tickets.film_id = films.id
    WHERE customer_id = $1;"

    value = [@id]
    films = SqlRunner.run(sql, value)
    return films.map {|film| Film.new(film)}
  end

  def buy_tickets(film, screening, number)
    ticket = Ticket.new({"customer_id" => @id, "film_id" => film.id})
    ticket.save
    @funds = @funds - film.price
    screening.deduct_tickets(number)
  end

  def how_many_tickets
    sql = "SELECT * FROM tickets WHERE customer_id = $1"
    value = [@id]
    tickets = SqlRunner.run(sql, value)
    return tickets.count
  end

  def self.map_items(rows)
    return rows.map { |row| Customer.new(row)}
  end

end
