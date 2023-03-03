require_relative 'user'

class UserRepository

  # Selecting all records
  # No arguments
  def all
    users = []
    # Executes the SQL query:
    sql = 'SELECT id, username, email_address FROM users;'

    result_set = DatabaseConnection.exec_params(sql, [])

    result_set.each do |record|
      user = User.new
      user.username = record['username']
      user.email_address = record['email_address']
      users << user
    end
    # Returns an array of User objects.
    return users
  end

  # Gets a single record by its ID
  # One argument: the id (number)
  def find(id)
    # Executes the SQL query:
    sql = 'SELECT id, username, email_address FROM users WHERE id = $1;'
    sql_params = [id]

    result = DatabaseConnection.exec_params(sql, sql_params)
    
    record = result[0]
    
    user = User.new
    user.id = record['id'].to_i
    user.username = record['username']
    user.email_address = record['email_address']
    # Returns a single User object.
    return user
  end

  # Create a new record
  # given a new User Object
  def create(user)
    # Executes the SQL query:
    sql = 'INSERT INTO users (username, email_address) VALUES($1, $2);'
    sql_params = [user.username, user.email_address]

    DatabaseConnection.exec_params(sql, sql_params)
    # Does not return a value
  end

  # Deletes a record
  # given an id value
  def delete(id)
    # Executes the SQL query:
    sql = 'DELETE FROM users WHERE id = $1;'
    sql_params = [id]

    DatabaseConnection.exec_params(sql, sql_params)
    # Does not return a value
  end

  # Updates a record
  # given a User Object
  def update(user)
    # Executes the SQL query:
    sql = 'UPDATE users SET username = $1, email_address = $2 WHERE id = $3;'
    sql_params = [user.username, user.email_address, user.id]

    DatabaseConnection.exec_params(sql, sql_params)
    # Does not return a value
  end

end