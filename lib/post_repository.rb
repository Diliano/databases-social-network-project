require_relative 'post'

class PostRepository

  # Selecting all records
  # No arguments
  def all
    posts = []
    # Executes the SQL query:
    sql = 'SELECT id, title, content, views, user_id FROM posts;'

    result_set = DatabaseConnection.exec_params(sql, [])

    result_set.each do |record|
      post = Post.new
      post.id = record['id'].to_i
      post.title = record['title']
      post.content = record['content']
      post.views = record['views'].to_i
      post.user_id = record['user_id'].to_i
      posts << post
    end
    # Returns an array of Post objects.
    return posts
  end

  # Gets a single record by its ID
  # One argument: the id (number)
  def find(id)
    # Executes the SQL query:
    sql = 'SELECT id, title, content, views, user_id FROM posts WHERE id = $1;'
    sql_params = [id]

    result = DatabaseConnection.exec_params(sql, sql_params)
    record = result[0]

    post = Post.new
    post.id = record['id'].to_i
    post.title = record['title']
    post.content = record['content']
    post.views = record['views'].to_i
    post.user_id = record['user_id'].to_i
    # Returns a single Post object.
    return post
  end

  # Create a new record
  # given a new Post Object
  def create(post)
    # Executes the SQL query:
    sql = 'INSERT INTO posts (title, content, views, user_id) VALUES($1, $2, $3, $4);'
    sql_params = [post.title, post.content, post.views, post.user_id]

    DatabaseConnection.exec_params(sql, sql_params)
    # Does not return a value
  end

  # Deletes a record
  # given an id value
  def delete(id)
    # Executes the SQL query:
    sql = 'DELETE FROM posts WHERE id = $1;'
    sql_params = [id]

    DatabaseConnection.exec_params(sql, sql_params)
    # Does not return a value
  end

  # Updates a record
  # given a Post Object
  def update(post)
    # Executes the SQL query:
    sql = 'UPDATE posts 
              SET title = $1, content = $2, views = $3, user_id = $4 
              WHERE id = $5;'
    sql_params = [post.title, post.content, post.views, post.user_id, post.id]

    DatabaseConnection.exec_params(sql, sql_params)
    # Does not return a value
  end

end