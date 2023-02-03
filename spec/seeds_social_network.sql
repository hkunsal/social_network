TRUNCATE TABLE users, posts RESTART IDENTITY;

INSERT INTO users (email, username) 
VALUES ('user1@example.com', 'user1');

INSERT INTO users (email, username) 
VALUES ('hkunsal@gmail.com', 'handekucukunsal');

INSERT INTO users (email, username)
VALUES ('alismith@gmail.com', 'alismith');

INSERT INTO posts (user_id, title, content, number_of_views) 
VALUES (1, 'Hello World!', 'This is my first post.', 50);

-- SQL seed data for the fourth user story
INSERT INTO posts (user_id, title, content, number_of_views) 
VALUES (2, 'My Second Post', 'This is my second post.', 100);

-- SQL seed data for the fifth user story
INSERT INTO posts (user_id, title, content, number_of_views) 
VALUES (3, 'My Third Post', 'This is my third post.', 300);