# Users Model and Repository Classes Design Recipe

_Copy this recipe template to design and implement Model and Repository classes for a database table._

## 1. Design and create the Table

If the table is already created in the database, you can skip this step.

## 2. Create Test SQL seeds

Your tests will depend on data stored in PostgreSQL to run.

If seed data is provided (or you already created it), you can skip this step.

```sql
-- (file: spec/seeds_users.sql)

-- Write your SQL seed here. 

-- First, you'd need to truncate the table - this is so our table is emptied between each test run,
-- so we can start with a fresh state.
-- (RESTART IDENTITY resets the primary key)

TRUNCATE TABLE users, posts RESTART IDENTITY; -- replace with your own table name.

-- Below this line there should only be `INSERT` statements.
-- Replace these statements with your own seed data.

INSERT INTO users (username, email_address) VALUES ('firstuser', 'firstuser@mail.com');
INSERT INTO users (username, email_address) VALUES ('seconduser', 'seconduser@mail.com');
INSERT INTO users (username, email_address) VALUES ('thirduser', 'thirduser@mail.com');

INSERT INTO posts (title, content, views, user_id) VALUES ('first post', 'intro', 1, 1);

```

Run this SQL file on the database to truncate (empty) the table, and insert the seed data. Be mindful of the fact any existing records in the table will be deleted.

```bash
psql -h 127.0.0.1 social_network_test < seeds_users.sql
```

## 3. Define the class names

Usually, the Model class name will be the capitalised table name (single instead of plural). The same name is then suffixed by `Repository` for the Repository class name.

```ruby
# Table name: users

# Model class
# (in lib/user.rb)
class User
end

# Repository class
# (in lib/user_repository.rb)
class UserRepository
end
```

## 4. Implement the Model class

Define the attributes of your Model class. You can usually map the table columns to the attributes of the class, including primary and foreign keys.

```ruby
# Table name: users

# Model class
# (in lib/user.rb)

class User

  # Replace the attributes by your own columns.
  attr_accessor :id, :username, :email_address
end

# The keyword attr_accessor is a special Ruby feature
# which allows us to set and get attributes on an object,
# here's an example:
#
# student = Student.new
# student.name = 'Jo'
# student.name
```

*You may choose to test-drive this class, but unless it contains any more logic than the example above, it is probably not needed.*

## 5. Define the Repository Class interface

Your Repository class will need to implement methods for each "read" or "write" operation you'd like to run against the database.

Using comments, define the method signatures (arguments and return value) and what they do - write up the SQL queries that will be used by each method.

```ruby
# Table name: users

# Repository class
# (in lib/user_repository.rb)

class UserRepository

  # Selecting all records
  # No arguments
  def all
    # Executes the SQL query:
    # SELECT id, username, email_address FROM users;

    # Returns an array of User objects.
  end

  # Gets a single record by its ID
  # One argument: the id (number)
  def find(id)
    # Executes the SQL query:
    # SELECT id, username, email_address FROM users WHERE id = $1;

    # Returns a single User object.
  end

  # Create a new record
  # given a new User Object
  def create(user)
    # Executes the SQL query:
    # INSERT INTO users (username, email_address) VALUES($1, $2);

    # Does not return a value
  end

  # Deletes a record
  # given an id value
  def delete(id)
    # Executes the SQL query:
    # DELETE FROM users WHERE id = $1;

    # Does not return a value
  end

  # Updates a record
  # given a User Object
  def update(user)
    # Executes the SQL query:
    # UPDATE users SET username = $1, email_address = $2 WHERE id = $3;

    # Does not return a value
  end

end
```

## 6. Write Test Examples

Write Ruby code that defines the expected behaviour of the Repository class, following your design from the table written in step 5.

These examples will later be encoded as RSpec tests.

```ruby
# EXAMPLES

# 1
# Get all users

repo = UserRepository.new

users = repo.all

users.length # => 3

users[0].username # => 'firstuser'
users[0].email_address # => 'firstuser@mail.com' 

users[1].username # => 'seconduser'
users[1].email_address # => 'seconduser@mail.com' 

users[2].username # => 'thirduser'
users[2].email_address # => 'thirduser@mail.com' 

# 2
# Get a single user

repo = UserRepository.new

user = repo.find(1)

user.id # => 1
user.username # => 'firstuser'
user.email_address # => 'firstuser@mail.com' 

# 3
# Get a single user

repo = UserRepository.new

user = repo.find(2)

user.id # => 2
user.username # => 'seconduser'
user.email_address # => 'seconduser@mail.com' 

# 4 
# Create a single user

repo = UserRepository.new

user = User.new
user.username = 'fourthuser'
user.email_address = 'fourthuser@mail.com'

repo.create(user)

users = repo.all

last_added = users.last

last_added.username # => 'fourthuser'
last_added.email_address # => 'fourthuser@mail.com'

# 5
# Deletes a single user

repo = UserRepository.new

repo.delete(3)

users = repo.all

users.length # => 2
users.last.username # => 'seconduser'
users.last.email_address # => 'seconduser@mail.com'

# 6 
# Updates a single user record

repo = UserRepository.new

user = repo.find(1)

user.username = 'nolongerfirst'

repo.update(user)

updated_user = repo.find(1)

updated_user.username # => 'nolongerfirst'
updated_user.email_address # => 'firstuser@mail.com'

```

Encode this example as a test.

## 7. Reload the SQL seeds before each test run

Running the SQL code present in the seed file will empty the table and re-insert the seed data.

This is so you get a fresh table contents every time you run the test suite.

```ruby
# EXAMPLE

# file: spec/user_repository_spec.rb

def reset_users_table
  seed_sql = File.read('spec/seeds_users.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'social_network_test' })
  connection.exec(seed_sql)
end

describe UserRepository do
  before(:each) do 
    reset_users_table
  end

  # (your tests will go here).
end
```

## 8. Test-drive and implement the Repository class behaviour

_After each test you write, follow the test-driving process of red, green, refactor to implement the behaviour._
