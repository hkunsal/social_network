require 'post'

class PostRepository

  # Selecting all records
  # No arguments
  def all
    sql = 'SELECT id, title, content, number_of_views, user_id FROM posts;'
    sql_params = []

    result_set = DatabaseConnection.exec_params(sql, [])

    posts = []

    result_set.each do |record|
      post = Post.new
      post.id = record['id']
      post.title = record['title']
      post.content = record['content']
      post.number_of_views = record['number_of_views']
      post.user_id = record['user_id']
  
      posts << post
    end
    
    return posts
    # Returns an array of Post objects.
  end

  # Selects a single method
  # Given the id in argument (a number)

  def find(id)
    sql = 'SELECT id, title, content, number_of_views, user_id FROM posts WHERE id = $1;'
    sql_params = [id]

    result_set = DatabaseConnection.exec_params(sql, sql_params)

    record = result_set[0]
    post = Post.new
    post.id = record['id']
    post.title = record['title']
    post.content = record['content']
    post.number_of_views = record['number_of_views']
    post.user_id = record['user_id']

    return post

    # Returns a single Post object
  end

  # Insert a new artist record
  # Takes a new Artist object in argument
  def create(post)
    sql = 'INSERT INTO posts (title, content, number_of_views, user_id) VALUES($1, $2, $3, $4);'
    sql_params = [post.title, post.content, post.number_of_views, post.user_id]

    DatabaseConnection.exec_params(sql, sql_params)

    return nil
  end

  # Delete an artist record
  # given its id
  def delete(id)
    sql = 'DELETE FROM posts WHERE id = $1;'
    sql_params = [id]
    
    DatabaseConnection.exec_params(sql, sql_params)

    return nil
  end

  # Updates an artist record
  # Takes an Artist object (with the updated fields)
  def update(post)
    sql = 'UPDATE posts SET title = $1, content = $2, number_of_views = $3 WHERE id = $4;'
    sql_params = [post.title, post.content, post.number_of_views, post.id]

    DatabaseConnection.exec_params(sql, sql_params)

    return nil
  end

end