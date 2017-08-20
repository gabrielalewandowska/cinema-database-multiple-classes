require_relative("../db/sql_runner")
require_relative("customer")
require_relative("film")


class Ticket

  attr_reader(:id, :customer_id, :film_id)

  def initialize(params)
    @id = params["id"].to_i
    @customer_id = params["customer_id"].to_i
    @film_id = params["film_id"].to_i
  end

  def save
    sql = "INSERT INTO tickets
    (customer_id, film_id) VALUES ($1, $2) RETURNING id"

    values = [@customer_id, @film_id]
    ticket = SqlRunner.run(sql, values).first
    @id = ticket["id"].to_i
  end

  def self.delete_all()
    sql = "DELETE FROM tickets"
    values = []
    SqlRunner.run(sql, values)
  end

  def self.all
    sql = "SELECT * FROM tickets"
    tickets = SqlRunner.run(sql)
    return Ticket.map_items(tickets)
  end

  def delete
    sql = "DELETE FROM tickets WHERE id = $1;"
    value = [@id]
    SqlRunner.run(sql, value)
  end

  def self.map_items(rows)
    return rows.map { |row| Ticket.new(row)}
  end

end
