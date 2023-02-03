require "database_connection"
require_relative 'user'

class UserRepository

  # Selecting all records
  # No arguments
  def all
    sql = 'SELECT id, email, username FROM users;'

    result_set = DatabaseConnection.exec_params(sql, [])

    users = []

    result_set.each do |record|
      user = User.new
      user.id = record['id']
      user.email = record['email']
      user.username = record['username']

      users << user
    end
  
    return users
  end

  # Selects a single method
  # Given the id in argument (a number)

  def find(id)
    sql = 'SELECT id, email, username FROM users WHERE id = $1;'
    sql_params = [id]

    result_set = DatabaseConnection.exec_params(sql, sql_params)

    record = result_set[0]
    user = User.new
    user.id = record['id']
    user.email = record['email']
    user.username = record['username']

    return user
  end

  # Insert a new artist record
  # Takes a new Artist object in argument
  def create(user)
    # Executes the SQL query:
    sql = 'INSERT INTO users (email, username) VALUES($1, $2);'

    sql_params = [user.email, user.username]

    DatabaseConnection.exec_params(sql, sql_params)

    return nil
    # Doesn't need to return anything (only creates the record)
  end

  # Delete an artist record
  # given its id
  def delete(id)
    # Executes the SQL:
    sql = 'DELETE FROM users WHERE id = $1;'

    sql_params = [id]

    DatabaseConnection.exec_params(sql, sql_params)
    
    return nil
    # Returns nothing (only deletes the record)
  end

  # Updates an user record
  # Takes an User object (with the updated fields)
  def update(user)
    # Executes the SQL:
    sql = 'UPDATE users SET email = $1, username = $2 WHERE id = $3;'
    sql_params = [user.email, user.username, user.id]

    DatabaseConnection.exec_params(sql, sql_params)

    return nil
    # Returns nothing (only updates the record)
  end

end