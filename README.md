# Student Roster Db From Schema

##Learning Competencies

* Use sqlite gem to create a database using Ruby commands
* Use sqlite gem to perform CRUD operations on tables in a database using Ruby commands

##Summary

| Ruby | SQL |
| :--- | :--- |
| a class named `Student` | a table named `students` |
| instances of the `Student` class | records/rows in the `students` table |
| attributes of `Student` objects | fields/columns in the `students` table |

*Figure 1.*  Mapping Ruby objects to database tables.


We've spent some time working with raw SQL to create tables and retrieve, update, and delete records.  Now we're going to begin using Ruby to interact with the database; see Figure 1 to see how Ruby objects map to database tables.  Ultimately, we'll be relying on the ActiveRecord gem to provide our classes with methods for interacting with a database.  This challenge is a step in that direction.


| Ruby Method | SQL Query |
| :--- | :--- |
| `Student.all` | `SELECT * FROM students;` |
| `Student.find(5)` | `SELECT * FROM students WHERE id = 5;` |
| `Student.where('first_name = ?', 'bob')` | `SELECT * FROM students WHERE first_name = 'bob';` |
| `new_student_instance.save` | `INSERT INTO students (first_name, ...) VALUES ('Jane', ...);` |

*Figure 2.*  Example Ruby methods and comparable SQL queries.

We are going to define a `Student` class.  We will write methods that mimic the behavior provided by ActiveRecord; in other words, we will recreate a scoped down version of the interface that Active Record provides—we won't recreate all the methods, just a sample.

Just as Ruby classes and database tables correlate, the methods we're going to write in this challenge are the Ruby counterparts to common SQL queries that we would run (see Figure 2).


### Class Methods

Some of the methods we write will be class methods.  The class methods will generally have the responsibility of retrieving records from the database and creating student objects based on the data.  We've already seen that a class is responsible for creating instances of itself through the `.new` class method (e.g., `Array.new`).  The class methods we'll write in our `Student` class will provide an expanded interface for instantiating students.

In this challenge, we'll write the class methods ...

- `.all` to return a collection of all the students

- `.find` to return a specific student found by its id

- `.where` to look for a specific value in a specific field and return a collection of students that match the condition

- `.all_by_birthday` to return a collection of all the students sorted by birthday

- `.find_by_first_name` to return a student object found by first name.

### Instance Methods

We will also write two instance methods: `#save` for saving records (inserting or updating) and `#delete` for deleting records.  In addition, we'll need to provide some accessor methods.

### SQLite3 Gem

We will be using the SQLite3 gem to connect to and interact with our database.

```ruby
$db = SQLite3::Database.new "students.db"
$db.results_as_hash = true
```
*Figure 3*.  Code to configure the database connection

The file `config.rb` establishes a connection with our database on configures how records are returned (see Figure 3).  We're creating a global variable, `$db` and assigning in the value of a `SQLite3::Database` object; the argument we pass to `.new` is the name of the database file we want to connect to.

Our interactions with the database will be handled by this database object.  For example, when our `Student` class needs to retrieve data from the database, the class will tell this database object to run a specific SQL query and then work with the results.


##Releases

###Release 0: Create and Setup the Student Database in Ruby

We're going to produce a database with a `students` table similar to the [student schema](https://github.com/bison-2014/database-drill-student-roster-challenge) from a previous challenge.

As a first step, ensure that the [Ruby gem for SQLite](https://github.com/luislavena/sqlite3-ruby) is installed.  From the command line, run ...

```bash
gem install sqlite3
```

Next, we're going to create the `students` table in the database and then put some data in the table. To begin, look at the file `student_db_setup.rb`. This file provides a module with two methods:  `.setup` to create the table and `.seed` to insert the data.

We are going to create and seed the `students` table by calling these methods on the `StudentDBSetup` module.  We'll do so by loading the `student_db_setup.rb` file ir irb.  From the command line, navigate to this challenge's `source` folder.  Then, open irb and run ...

```bash
:001 > load 'student_db_setup.rb'
```

Calling `load` and passing it the name of a file will load the code from the specificed file into the environment.  As a result, the `StudentDBSetup` module will be availble to us in this irb session.

We'll continue by creating the `students` table.  Look at the method `StudentDBSetup.setup`.  We can see that the `StudentDBSetup` module delegates to `$db`, our `SQLite3::Database` object, any tasks that relate to communicating with the database.  It does so using the [`Database#execute`](http://www.rubydoc.info/gems/sqlite3/1.3.10/SQLite3/Database#execute-instance_method) method, passing a string of SQL to be run.

Still within irb, to create the `students` table run ...

```bash
:002 > StudentDBSetup.setup
```

Next, to put some data into the table, run ...

```bash
:003 > StudentDBSetup.seed
```

At this point in our database, we should have a `students` table with some records in it. To verify this, from the command line, open up the SQLite3 console with the `students.db` database and make sure you can run `SELECT` on these records.

###Release 1:  Create the Interface for the Student Class

Now we're going to create the `Student` class methods that were described in the challenge summary (e.g., `Student.all`, `Student.find`, `Student#save`, etc. ).  Tests have been provided that describe the desired behavior of these methods—the behaviors mimic what you will encounter when you work with Active Record.

To complete this challenge, make all the tests pass.

***Note:***  The code for the `Student#save` method should be written first, as the other tests are dependent upon being able to save objects.

##Resources
<!-- ##Optimize Your Learning  -->


* [Ruby gem for SQLite](https://github.com/luislavena/sqlite3-ruby)
* [SQLite 3](http://www.sqlite.org/)
