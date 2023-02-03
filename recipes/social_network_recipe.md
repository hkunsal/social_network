# Artists Model and Repository Classes Design Recipe

_Copy this recipe template to design and implement Model and Repository classes for a database table._

## 1. Design and create the Table

1. Extract nouns from the user stories or specification

```
# EXAMPLE USER STORY:

As a social network user,
So I can have my information registered,
I'd like to have a user account with my email address.

As a social network user,
So I can have my information registered,
I'd like to have a user account with my username.

As a social network user,
So I can write on my timeline,
I'd like to create posts associated with my user account.

As a social network user,
So I can write on my timeline,
I'd like each of my posts to have a title and a content.

As a social network user,
So I can know who reads my posts,
I'd like each of my posts to have a number of views.
```

```
Nouns:

users, email, username

posts, user, title, content, number of views
```

## 2. Infer the Table Name and Columns

Put the different nouns in this table. Replace the example with your own nouns.

| Record                | Properties          |
| --------------------- | ------------------  |
| users                 | email, username
| posts                 | user, title, content, number_of_views

1. Name of the first table (always plural): `users` 

    Column names: `email`, `username`

2. Name of the second table (always plural): `posts` 

    Column names: `title`, `content`, `number_of_views`

## 3. Decide the column types.

[Here's a full documentation of PostgreSQL data types](https://www.postgresql.org/docs/current/datatype.html).

Most of the time, you'll need either `text`, `int`, `bigint`, `numeric`, or `boolean`. If you're in doubt, do some research or ask your peers.

Remember to **always** have the primary key `id` as a first column. Its type will always be `SERIAL`.

```
# EXAMPLE:

Table: users
id: SERIAL
email: text
username: text

Table: posts
id: SERIAL
title: text
content: text
number of views: int
```

## 4. Decide on The Tables Relationship

Most of the time, you'll be using a **one-to-many** relationship, and will need a **foreign key** on one of the two tables.

To decide on which one, answer these two questions:

1. Can one [TABLE ONE] have many [TABLE TWO]? (Yes/No)
2. Can one [TABLE TWO] have many [TABLE ONE]? (Yes/No)

You'll then be able to say that:

1. **[A] has many [B]**
2. And on the other side, **[B] belongs to [A]**
3. In that case, the foreign key is in the table [B]

Replace the relevant bits in this example with your own:

```
# EXAMPLE

1. Can one user have many posts? YES
2. Can one post have many users? NO

-> Therefore,


-> A user HAS MANY posts
-> A post BELONGS TO a user

-> Therefore, the foreign key is on the posts table.
-- file: albums_table.sql

-- Replace the table name, columm names and types.

-- Create the table without the foreign key first.

CREATE TABLE users ( 
  id SERIAL PRIMARY KEY, 
  email text, 
  username text 
);

-- Then the table with the foreign key.
CREATE TABLE posts ( 
  id SERIAL PRIMARY KEY, 
  title text, 
  content text, 
  number_of_views int, 
  user_id int, 
  constraint fk_user foreign key(user_id) 
    references users(id) 
    on delete cascade 
);


```

## 5. Create the tables.

```bash
psql -h 127.0.0.1 database_name < albums_table.sql
```

## 2. Create Test SQL seeds

Your tests will depend on data stored in PostgreSQL to run.

If seed data is provided (or you already created it), you can skip this step.

```sql
-- EXAMPLE
-- (file: spec/seeds_{table_name}.sql)

-- Write your SQL seed here. 

-- First, you'd need to truncate the table - this is so our table is emptied between each test run,
-- so we can start with a fresh state.
-- (RESTART IDENTITY resets the primary key)

TRUNCATE TABLE users RESTART IDENTITY; -- replace with your own table name.
TRUNCATE TABLE posts RESTART IDENTITY;
-- Below this line there should only be `INSERT` statements.
-- Replace these statements with your own seed data.

INSERT INTO users (email, username) 
VALUES ('user1@example.com', 'user1');

INSERT INTO posts (user_id, title, content) 
VALUES (1, 'Hello World!', 'This is my first post.');

-- SQL seed data for the fourth user story
INSERT INTO posts (user_id, title, content) 
VALUES (1, 'My Second Post', 'This is my second post.');

-- SQL seed data for the fifth user story
INSERT INTO posts (user_id, title, content, number_of_views) 
VALUES (1, 'My Third Post', 'This is my third post.', 0);


```

Run this SQL file on the database to truncate (empty) the table, and insert the seed data. Be mindful of the fact any existing records in the table will be deleted.

```bash
psql -h 127.0.0.1 your_database_name < seeds_social_network.sql
```

## 3. Define the class names

Usually, the Model class name will be the capitalised table name (single instead of plural). The same name is then suffixed by `Repository` for the Repository class name.

```ruby
# EXAMPLE
# Table name: users

# Model class
# (in lib/artist.rb)
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
# EXAMPLE
# Table name: users

# Model class
# (in lib/user.rb)

class User

  # Replace the attributes by your own columns.
  attr_accessor :id, :name, :cohort_name
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
# EXAMPLE
# Table name: artists

# Repository class
# (in lib/artist_repository.rb)

class UserRepository

  # Selecting all records
  # No arguments
  def all
    # Executes the SQL query:
    # SELECT id, email, username FROM users;

    # Returns an array of Artist objects.
  end

  # Selects a single method
  # Given the id in argument (a number)

  def find(id)
    # Executes the SQL query:
    # SELECT id, email, username FROM users WHERE id = $1;

    # Returns a single Artist object
  end

  # Insert a new artist record
  # Takes a new Artist object in argument
  def create(user)
    # Executes the SQL query:
    # INSERT INTO users (email, username) VALUES($1, $2);

    # Doesn't need to return anything (only creates the record)
  end

  # Delete an artist record
  # given its id
  def delete(id)
    # Executes the SQL:
    # DELETE FROM users WHERE id = $1;

    # Returns nothing (only deletes the record)
  end

  # Updates an artist record
  # Takes an Artist object (with the updated fields)
  def update(artist)
    # Executes the SQL:
    # UPDATE artists SET email = $1, username = $2 WHERE id = $3;

    # Returns nothing (only updates the record)
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
users.length # => 2
users.first.id # => 1
users.first.email # => 'Pixies'

# 2
# Get a single artist

repo = UserRepository.new

user = repo.find(1) 
user.email # => 'Pixies'
user.username # => 'Rock'

# 3
# Get another single artist

repo = UserRepository.new

user = repo.find(2) 
user.email # => 'ABBA'
user.username # => 'Pop'

# 4
# Create a new artist

repo = UserRepository.new

user = User.new
user.email = 'Beatles'
user.username = 'Pop'

repo.create(user) # => nil

users = repo.all

last_user = artists.last
last_user.email # => 'Beatles'
last_user.username # => 'Pop'

# 5
# Delete an artist
repo = UserRepository.new
id_to_delete = 1

repo.delete(id_to_delete)

all_users = repo.all

all_users.length # => 1
all_users.first.id # => '2'

# 6
# Updates an artist

repo = UserRepository.new

user = repo.find(1)
user.email = 'Something else'
user.username = 'Disco'

repo.update(user)

updated_user = repo.find(1)
updated_user.email # => 'Something else'
updated_user.username # => 'Disco'
```

Encode this example as a test.

## 7. Reload the SQL seeds before each test run

Running the SQL code present in the seed file will empty the table and re-insert the seed data.

This is so you get a fresh table contents every time you run the test suite.

```ruby
# EXAMPLE

# file: spec/student_repository_spec.rb

def reset_students_table
  seed_sql = File.read('spec/seeds_students.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'students' })
  connection.exec(seed_sql)
end

describe StudentRepository do
  before(:each) do 
    reset_students_table
  end

  # (your tests will go here).
end
```

## 8. Test-drive and implement the Repository class behaviour

_After each test you write, follow the test-driving process of red, green, refactor to implement the behaviour._

<!-- BEGIN GENERATED SECTION DO NOT EDIT -->

---

**How was this resource?**  
[😫](https://airtable.com/shrUJ3t7KLMqVRFKR?prefill_Repository=makersacademy%2Fdatabases&prefill_File=resources%2Frepository_class_recipe_template.md&prefill_Sentiment=😫) [😕](https://airtable.com/shrUJ3t7KLMqVRFKR?prefill_Repository=makersacademy%2Fdatabases&prefill_File=resources%2Frepository_class_recipe_template.md&prefill_Sentiment=😕) [😐](https://airtable.com/shrUJ3t7KLMqVRFKR?prefill_Repository=makersacademy%2Fdatabases&prefill_File=resources%2Frepository_class_recipe_template.md&prefill_Sentiment=😐) [🙂](https://airtable.com/shrUJ3t7KLMqVRFKR?prefill_Repository=makersacademy%2Fdatabases&prefill_File=resources%2Frepository_class_recipe_template.md&prefill_Sentiment=🙂) [😀](https://airtable.com/shrUJ3t7KLMqVRFKR?prefill_Repository=makersacademy%2Fdatabases&prefill_File=resources%2Frepository_class_recipe_template.md&prefill_Sentiment=😀)  
Click an emoji to tell us.

<!-- END GENERATED SECTION DO NOT EDIT -->