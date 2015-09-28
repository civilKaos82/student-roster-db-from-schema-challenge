# Write a Class Backed by a Database

## Summary
| Ruby | SQL |
| :--- | :--- |
| a class named `Student` | a table named `students` |
| instances of the `Student` class | records/rows in the `students` table |
| attributes of `Student` objects | fields/columns on the `students` table |

*Table 1.*  Mapping Ruby objects to database tables.

We've spent some time working with databases using raw SQL to create tables and to create, retrieve, update, and delete records.  Now we're going to begin using Ruby to interact with the database.  At the end of this challenge, we'll have built a `Student` class that is backed by a `students` table in our database (see Figure 1 to see how Ruby objects map to database tables).

| Ruby Method | SQL Query |
| :--- | :--- |
| `Student.all` | `SELECT * FROM students;` |
| `Student.find(5)` | `SELECT * FROM students WHERE id = 5;` |
| `Student.where('first_name = ?', 'bob')` | `SELECT * FROM students WHERE first_name = 'bob';` |
| `new_student_instance.save` | `INSERT INTO students (first_name, ...) VALUES ('Jane', ...);` |

*Table 2.*  Example Ruby methods and comparable SQL queries.

As we progress through Dev Bootcamp, we'll eventually come to rely on the Active Record gem to provide our classes with behaviors for interacting with a database.  After learning some SQL, this challenge is another step in that direction.

We are going to define a `Student` class.  We will write methods that mimic the behaviors provided by ActiveRecord; in other words, we will recreate a scoped down version of the interface that Active Record provides—we won't recreate all the methods, just a sample.

Just as Ruby classes and database tables correlate, the methods we're going to write in this challenge are the Ruby counterparts to common SQL queries that we would run (see Table 2).


### Class Methods
Some of the methods we write will be class methods.  The class methods will generally have the responsibility of retrieving records from the database and creating student objects based on the data.  We've already seen that a class is responsible for creating instances of itself through the `.new` class method (e.g., `Array.new`).  The class methods we'll write in our `Student` class will provide an expanded interface for instantiating students.

In this challenge, we'll write the class methods ...

- `.all` to return a collection of all the students in the database.

- `.find` to return a specific student found in the database by its id.

- `.where` to look for a specific value in a specific field and return a collection of students from the database that match the condition.

- `.all_by_birthday` to return a collection of all the students in the database sorted by birthday.

- `.find_by_first_name` to return a student object found in the database by first name.


### Instance Methods
We will also write two instance methods: `#save` for saving records (inserting or updating) and `#delete` for deleting records.  In addition, we'll need to provide some accessor methods for object attributes.


### SQLite3 Gem
We will be using the SQLite3 gem to connect to and interact with our database.

```ruby
$db = SQLite3::Database.new "students.db"
$db.results_as_hash = true
```
*Figure 1*.  The code in `config.rb` configures the database connection.

The file `config.rb` establishes a connection with our database and configures how records are returned (see Figure 1).  In this file we're creating a global variable, `$db` and assigning it the value of a `SQLite3::Database` object; the argument we pass to `.new` is the name of the database file we want to connect to.

Our interactions with the database will be handled by this database object.  For example, when our `Student` class needs to retrieve data from the database, the class will tell this database object to run a specific SQL query and then work with the results.


## Releases
### Pre-release: Create and Setup the Database
Before we can write a class that interacts with a database, we need to create the database and create in it a table to store data.  To that end we're going to create a database with a `students` table and then insert some data into the table.  All of the code to do this is provided in the file `student_db_setup.rb`.  We'll load the file in IRB and then execute the provided code.

```
gem install sqlite3
```
*Figure 2*. Installing the SQLite3 gem.

As a first step, let's ensure that the [Ruby gem for SQLite](https://github.com/luislavena/sqlite3-ruby) is installed.  From the command line, run the code in Figure 2.

With SQLite3 installed, we're now going to create the `students` table in the database and then put some data in the table (i.e., seed it). To begin, look at the file `student_db_setup.rb`. This file provides a module with two methods:  `.create_students_table` to create the table and `.seed` to insert the data.  We are going to create and seed the `students` table by calling these methods on the `StudentDBSetup` module.

```
$ irb
:001 > load 'student_db_setup.rb'
:002 > StudentDBSetup.create_students_table
:003 > StudentDBSetup.seed
:004 > exit
```
*Figure 3*.  Loading and running the code to create and seed the students table in IRB.

Let's begin by opening IRB and executing the code shown in Figure 3.  In this code, we first load the `student_db_setup.rb` file.  Calling `load` and passing in the name of a file will load the code from the specified file into the environment.  As a result, the `StudentDBSetup` module will be available to us in this IRB session.

We continue by creating the `students` table.  Look at the method `StudentDBSetup.create_students_table`.  We can see that the `StudentDBSetup` module delegates to `$db`, our `SQLite3::Database` object, any tasks that relate to communicating with the database.  It does so using the [`Database#execute`](http://www.rubydoc.info/gems/sqlite3/1.3.10/SQLite3/Database#execute-instance_method) method, passing a string of SQL to be run.  And finally, we insert some records into the database by calling `StudentDBSetup.seed`.

At this point we should have a `students` table with some records in it. To verify this, exit IRB.  Then, from the command line, open up the SQLite3 console with the `database.db` database and select all the records from the `students` table.  The result should match the values being inserted in the `.seed` method.


### Release 0: Create the Student Class
With the `students` table in the database, now it's time to build our class.  Take a look at the methods that were described in the *Summary*—both the class and instance methods.  We're going to write each of these.

Tests have been provided that describe the desired behavior of each method—the behaviors mimic what we'll encounter when we work with Active Record.  To complete this challenge, we need to make all the tests pass.

*Note:*  The code for the `Student#save` method should be written first, as the other tests are dependent upon being able to save objects.


### Release 1: Use the Student Class
```
$ irb
:001 > load 'config.rb'
:002 > load 'student.rb'
:003 > Student.all
:004 >
```
*Figure 4*. Loading and using the `Student` class in IRB.

We just built a class that interacts with a database.  Let's use it (see Figure 4).  Use the methods that we just wrote to create new records in the database, retrieve records from the database, and delete records from the database.


## Conclusion
In this challenge we've begun to move away from writing SQL.  We'll be working with databases throughout Dev Bootcamp, but we'll be seeing less and less SQL. The SQL will still be executed and we need to understand what it does, but it will be hidden behind Ruby.

Already with our `Student` class, we can work totally in Ruby but have SQL executed in the background.  We are still interacting with a database and ultimately SQL is being executed, but we only need to know which Ruby methods to call.