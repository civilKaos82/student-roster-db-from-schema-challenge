# Student Roster Db From Schema

##Learning Competencies

* Use sqlite gem to create a database using Ruby commands
* Use sqlite gem to perform CRUD operations on tables in a database using Ruby commands

##Summary

It's time to start building the databases from all those schema we designed, and we'll use Ruby to do it.

##Releases

###Release 0 : Create the student database in Ruby

Revisit the [Student Roster Challenge](../../../database-drill-student-roster-challenge) and write a ruby program that creates the database from this schema in the source file `student_roster.rb`.

First, include the [Ruby gem for SQLite](https://github.com/luislavena/sqlite3-ruby).  Install it by running:

```bash
gem install sqlite3
```

Next, look at `student_db_helper.rb`. This provides tools to create and seed the database. It's not complete, you'll need to update it to accomplish your task.

Add the following records to your seed method:

| Name         | Birthday   |
| ------------ | ---------- |
| Alyssa Diaz  | 1977-07-04 |
| Matt Jones   | 1978-07-04 |
| Matt Baker   | 1984-07-04 |
| Lauren Scott | 1990-05-04 |
| Dave Hoover  | 1974-07-04 |

Verify your database is working properly.

Load `student_db_helper.rb` file in irb and run the `StudentDBHelper.setup`  and `StudentDBHelper.seed` methods. Then open up the Sqlite console with the `students.db` database and make sure you can run `SELECT` on these records.

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

- Add a student
- Delete a student
- Show a list of all students
- Show a list of students with a particular first_name
- Show a list of students with any particular attribute
- List which students have a birthday this month
- List students by birthday

*Specs have been provided for you as a guide to writing these methods in `student_spec.rb`*

<!-- ##Optimize Your Learning  -->

##Resources

* [Ruby gem for SQLite](https://github.com/luislavena/sqlite3-ruby)
* [SQLite 3](http://sqlite-ruby.rubyforge.org/sqlite3)
