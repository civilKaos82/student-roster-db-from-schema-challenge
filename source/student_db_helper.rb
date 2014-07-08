require 'sqlite3'
require_relative 'student_db'

module StudentDBHelper
  def self.setup
    #Drop the table if it exists, because we're re-creating it
    $db.execute("DROP TABLE IF EXISTS students")

    #Note: this table structure doesn't include all the fields you'll need...
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
    #Delete existing rows before seed
    $db.execute("DELETE FROM students")

    # Add a few records to your database when you start.
    # You'll need more than this one row, so read the README carefully.
    $db.execute(
      <<-SQL
        INSERT INTO students
          (first_name, last_name, birthday, created_at, updated_at)
        VALUES
          ('Brick','Thornton', DATETIME('1971-07-04'), DATETIME('now'), DATETIME('now'));
      SQL
    )
  end
end
