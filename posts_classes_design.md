# Posts Model and Repository Classes Design Recipe

_Copy this recipe template to design and implement Model and Repository classes for a database table._

## 1. Design and create the Table

If the table is already created in the database, you can skip this step.

## 2. Create Test SQL seeds

Your tests will depend on data stored in PostgreSQL to run.

If seed data is provided (or you already created it), you can skip this step.

```sql
-- (file: spec/seeds_posts.sql)

-- Write your SQL seed here. 

-- First, you'd need to truncate the table - this is so our table is emptied between each test run,
-- so we can start with a fresh state.
-- (RESTART IDENTITY resets the primary key)

TRUNCATE TABLE users, posts RESTART IDENTITY; -- replace with your own table name.

-- Below this line there should only be `INSERT` statements.
-- Replace these statements with your own seed data.

INSERT INTO users (username, email_address) VALUES ('firstuser', 'firstuser@mail.com');

INSERT INTO posts (title, content, views, user_id) VALUES ('first post', 'intro', 1, 1);
INSERT INTO posts (title, content, views, user_id) VALUES ('second post', 'middle', 10, 1);
INSERT INTO posts (title, content, views, user_id) VALUES ('third post', 'end', 20, 1);

```

Run this SQL file on the database to truncate (empty) the table, and insert the seed data. Be mindful of the fact any existing records in the table will be deleted.

```bash
psql -h 127.0.0.1 social_network_test < seeds_posts.sql
```

## 3. Define the class names

Usually, the Model class name will be the capitalised table name (single instead of plural). The same name is then suffixed by `Repository` for the Repository class name.

```ruby
# Table name: posts

# Model class
# (in lib/post.rb)
class Post
end

# Repository class
# (in lib/post_repository.rb)
class PostRepository
end
```

## 4. Implement the Model class

Define the attributes of your Model class. You can usually map the table columns to the attributes of the class, including primary and foreign keys.

```ruby
# Table name: posts

# Model class
# (in lib/post.rb)

class Post

  # Replace the attributes by your own columns.
  attr_accessor :id, :title, :content, :views, :user_id
end

```

*You may choose to test-drive this class, but unless it contains any more logic than the example above, it is probably not needed.*

## 5. Define the Repository Class interface

Your Repository class will need to implement methods for each "read" or "write" operation you'd like to run against the database.

Using comments, define the method signatures (arguments and return value) and what they do - write up the SQL queries that will be used by each method.

```ruby
# Table name: posts

# Repository class
# (in lib/post_repository.rb)

class PostRepository

  # Selecting all records
  # No arguments
  def all
    # Executes the SQL query:
    # SELECT id, title, content, views, user_id FROM posts;

    # Returns an array of Post objects.
  end

  # Gets a single record by its ID
  # One argument: the id (number)
  def find(id)
    # Executes the SQL query:
    # SELECT id, title, content, views, user_id FROM posts WHERE id = $1;

    # Returns a single Post object.
  end

  # Create a new record
  # given a new Post Object
  def create(post)
    # Executes the SQL query:
    # INSERT INTO posts (title, content, views, user_id) VALUES($1, $2, $3, $4);

    # Does not return a value
  end

  # Deletes a record
  # given an id value
  def delete(id)
    # Executes the SQL query:
    # DELETE FROM posts WHERE id = $1;

    # Does not return a value
  end

  # Updates a record
  # given a Post Object
  def update(post)
    # Executes the SQL query:
    # UPDATE posts 
    #   SET title = $1, content = $2, views = $3, user_id = $4 
    #   WHERE id = $5;

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
# Get all posts

repo = PostRepository.new

posts = repo.all

posts.length # => 3

posts[0].title # => 'first post'
posts[0].content # => 'intro'
posts[0].views # => 1
posts[0].user_id # => 1

posts[1].title # => 'second post'
posts[1].content # => 'middle'
posts[1].views # => 10
posts[1].user_id # => 1

posts[2].title # => 'third post'
posts[2].content # => 'end'
posts[2].views # => 20
posts[2].user_id # => 1

# 2
# Get a single post

repo = PostRepository.new

post = repo.find(1)

post.id # => 1
posts.title # => 'first post'
posts.content # => 'intro'
posts.views # => 1
posts.user_id # => 1

# 3 
# Create a new post

repo = PostRepository.new

post = Post.new
post.title = 'fourth post'
post.content = 'back again'
post.views = 50
post.user_id = 1

repo.create(post)

all_posts = repo.all
# => all_posts should contain the new post

# 4 
# Delete a single post

repo = PostRepository.new

repo.delete(1)

posts = repo.all

posts.length # => 2
posts.last.title # => 'third post'

# 5
# Update a single post

repo = PostRepository.new

post = repo.find(1)
post.title = 'nolongerfirstpost'

repo.update(post)

updated_post = repo.find(1)
updated_post.title # => 'nolongerfirstpost'
updated_post.content # => 'intro'

```

Encode this example as a test.

## 7. Reload the SQL seeds before each test run

Running the SQL code present in the seed file will empty the table and re-insert the seed data.

This is so you get a fresh table contents every time you run the test suite.

```ruby

# file: spec/post_repository_spec.rb

def reset_posts_table
  seed_sql = File.read('spec/seeds_posts.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'social_network_test' })
  connection.exec(seed_sql)
end

describe PostRepository do
  before(:each) do 
    reset_posts_table
  end

  # (your tests will go here).
end
```

## 8. Test-drive and implement the Repository class behaviour

_After each test you write, follow the test-driving process of red, green, refactor to implement the behaviour._
