require_relative("../db/sql_runner")
require_relative("film")
require_relative("ticket")
require_relative("customer")


class Screening

  attr_accessor(:available_tickets)
  attr_reader(:id, :film_id, :show_time)

  def initialize (params)
    @id = params["id"].to_i
    @film_id = params["film_id"].to_i
    @available_tickets = 20
    @show_time = params["show_time"]
  end

  def save
    sql = "INSERT INTO screenings
    (film_id, available_tickets, show_time)
    VALUES ($1, $2, $3)
    RETURNING ID"

    values = [@film_id, @available_tickets, @show_time]
    screening = SqlRunner.run(sql, values).first
    @id = screening["id"].to_i
  end

  def deduct_tickets(number)
    @available_tickets = @available_tickets - number
    sql = "UPDATE screenings SET available_tickets = $1 WHERE id = $2;"
    values = [@available_tickets, @id]
    SqlRunner.run(sql, values)  
  end
end
