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