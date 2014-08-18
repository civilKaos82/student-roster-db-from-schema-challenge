# Student Roster Db From Schema 
 
##Learning Competencies 

* Use sqlite gem to create a database using Ruby commands
* Use sqlite gem to perform CRUD operations on tables in a database using Ruby commands

##Summary 

 It's time to start building the databases from all those schema we designed, and we'll use Ruby to do it.  

##Releases

###Release 0 : Create the student database in Ruby

Revisit the [Student Schema]( http://socrates.devbootcamp.com/challenges/51)  and write a ruby program that creates the database from this schema in the source file `student_roster.rb`.  

First, include the [Ruby gem for SQLite](https://github.com/luislavena/sqlite3-ruby).  Install it by running:

```bash
gem install sqlite3
```

Next, create a file called `setup.rb`  that you will only run once to create your database.  Use the code below as a template to get you started. 

```ruby
require 'sqlite3'

# If you want to overwrite your database you will need 
# to delete it before running this file
$db = SQLite3::Database.new "students.db"

module StudentDB
  def self.setup
    $db.execute(
      <<-SQL
        CREATE TABLE students (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          first_name VARCHAR(64) NOT NULL,
          last_name VARCHAR(64) NOT NULL,
          
          -- add the additional attributes here!
          
          created_at DATETIME NOT NULL,
          updated_at DATETIME NOT NULL
        );
      SQL
    )
  end

  def self.seed
    # Add a few records to your database when you start
    $db.execute(
      <<-SQL
        INSERT INTO students 
          (first_name, last_name, created_at, updated_at)
        VALUES
          ('Brick','Thornton',DATETIME('now'), DATETIME('now'));

        -- Create two more students who are at least as cool as this one.
      SQL
    )
  end
end
```

Verify your database is working properly. 

Load your `setup.rb` file in irb and run the `StudentDB.setup`  and `StudentDB.seed` methods. Then open up the Sqlite console with the `students.db` database and make sure you can run `SELECT` on these records. 

###Release 1 :  Create the Student Class 

There are some clear parallels with the Ruby objects and the Database tables. 

<table class="table table-striped table-bordered">
  <tr>
    <th>SQL land</th>
    <th>Ruby land</th>
  </tr>
  <tr>
    <td>A table named <code>students</code></td>
    <td>A class named <code>Student</code></td>
  </tr>
  <tr>
    <td>A row from <code>students</code></td>
    <td>An instance of <code>Student</code></td>
  </tr>
 <tr>
    <td><pre>SELECT * FROM students </pre></td>
    <td><pre>Student.all</pre></td>
  </tr>
  <tr>
    <td><pre>SELECT * FROM students WHERE first_name = 'bob'<br><b>OR</b><br>SELECT * FROM students WHERE first_name = ? , 'bob'</pre></td>
    <td><pre>Student.where('first_name = ?', 'bob')</pre></td>
  </tr>
  <tr>
    <td><pre>SELECT * FROM students WHERE id = 10<br><b>OR</b><br>SELECT * FROM students WHERE id = ? , 10</pre></td>
    <td><pre>Student.where('id = ?', 10)</pre></td>
  </tr>
    <td><pre>INSERT INTO students (field1, field2, ...)
VALUES(value1, value2, ...)</pre></td>
    <td>
      <pre> student = Student.new(data)
student.save</pre>
    </td>
  </tr>
  <tr>
    <td><pre>DELETE FROM students WHERE id = 40</pre></td>
    <td>???</td>
  </tr>
</table>

<b>NOTE:</b> In the SQL above, two versions of `WHERE` clauses are given. In the second version, a SQL placeholder `?` is used.  This format helps avoid SQL injection attacks.  You can see more examples of [placeholders in WHERE clauses](http://sqlite-ruby.rubyforge.org/sqlite3/faq.html#538670816) and [place holders in INSERT clauses](http://sqlite-ruby.rubyforge.org/sqlite3/faq.html#538670616).


###Release 2 : Add methods to the Student Class to execute SQL commands

Then write Ruby code that allows you to complete the following tasks:

1. Add a student (note that this task is made up of 2 different methods as shown above)
- Delete a student
- Show a list of all students
- Show a list of students with a particular first_name 
- Show a list of students with any particular attribute
- List which students have a birthday this month
- List students by birthday 

*Use the table above as a guide for your methods.  What can you infer about each method's declaration and structure?*

<!-- ##Optimize Your Learning  -->

##Resources

* [Ruby gem for SQLite](https://github.com/luislavena/sqlite3-ruby)
* [SQLite 3](http://sqlite-ruby.rubyforge.org/sqlite3)
