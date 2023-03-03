## Challenge

This is a process feedback challenge. That means you should record yourself doing it and
submit that recording to your coach for feedback. 

This is a big one! To work on this challenge, first:
  * Setup a new project directory `social_network`.
  * Create a new database `social_network`.

Then:

1. Design the two tables for the following user stories.  

    ```
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

2. Test-drive the Model and Repository classes for these two tables.
    * You should end up with two Model classes and two Repository classes.
    * You should test-drive and implement the four methods `all`, `find`, `create` and
      `delete` for each Repository class.

3. If you'd like an extra challenge, test-drive as well an `update` method for both classes, which updates a specific record.
