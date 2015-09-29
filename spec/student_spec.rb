require_relative '../config'
require_relative '../student'

describe Student do
  describe 'object attributes' do
    it 'has a readable and writable first name' do
      student = Student.new('first_name' => 'Jackalyn')
      expect { student.first_name = 'Aminah' }.to change { student.first_name }.from('Jackalyn').to('Aminah')
    end

    it 'has a readable and writable last name' do
      student = Student.new('last_name' => 'Knaggs')
      expect { student.last_name = 'Arthur' }.to change { student.last_name }.from('Knaggs').to('Arthur')
    end

    it 'has a readable and writable gender' do
      student = Student.new('gender' => 'male')
      expect { student.gender = 'female' }.to change { student.gender }.from('male').to('female')
    end

    it 'has a readable and writable birthday' do
      student = Student.new('birthday' => '1781-05-22')
      expect { student.birthday = '1981-05-22' }.to change { student.birthday }.from('1781-05-22').to('1981-05-22')
    end

    it 'has a readable and writable email address' do
      student = Student.new('email' => 'email@address.com')
      expect { student.email = 'email@me.com' }.to change { student.email }.from('email@address.com').to('email@me.com')
    end

    it 'has a readable and writable phone number' do
      student = Student.new('phone' => '419-555-1234')
      expect { student.phone = '419-555-0000' }.to change { student.phone }.from('419-555-1234').to('419-555-0000')
    end
  end

  describe 'persistence' do
    # Start each test with no data in the students table.
    # We'll add the specific data we need for each test before running the test.
    before(:each) do
      $db.transaction
      $db.execute('DELETE FROM students')
    end

    # Undo changes to the database after each test.
    after(:each) do
      $db.rollback
    end

    describe 'attributes related to persistence' do
      it 'has a readable id' do
        student = Student.new('id' => 30)
        expect(student.id).to eq 30
      end

      it 'has a readable created at time' do
        student = Student.new('created_at' => '2015-09-29')
        expect(student.created_at).to eq '2015-09-29'
      end

      it 'has a readable updated at time' do
        student = Student.new('updated_at' => '2015-09-30')
        expect(student.updated_at).to eq '2015-09-30'
      end
    end

    describe 'retrieving data from the database' do
      describe 'returning multiple students' do
        describe '.all' do
          context 'when there are no students in the database' do
            it 'returns an empty collection' do
              expect(Student.all).to be_empty
            end
          end

          context 'when there are students in the database' do

            # Add student records to the database so that we can retrieve them in our tests.
            before(:each) do
              $db.execute(
                <<-SQL_INSERT_STATEMENT
                INSERT INTO students
                  (first_name, last_name, birthday, created_at, updated_at)
                VALUES
                  ('Danielle','Michael', DATETIME('1971-07-04'), DATETIME('now'), DATETIME('now')),
                  ('Tobin','Larue', DATETIME('1974-07-04'), DATETIME('now'), DATETIME('now'));
                SQL_INSERT_STATEMENT
              )
            end

            it 'returns a collection of student objects' do
              expect(Student.all).to all(be_an_instance_of(Student))
            end

            it 'returns a collection with all the students in it' do
              count_of_students_in_db = $db.get_first_value('SELECT COUNT(*) FROM students;')

              expect(Student.all.length).to eq count_of_students_in_db
            end
          end
        end

        describe ".where" do
          context 'when there are no students matching the specified conditions in the database' do
            it 'returns an empty collection' do
              expect(Student.where('first_name = ?', 'John')).to be_empty
            end
          end

          context 'when there are students matching the specified conditions in the database' do

            # Add student records to the database so that we can retrieve them in our tests.
            before(:each) do
              $db.execute(
                <<-SQL_INSERT_STATEMENT
                INSERT INTO students
                  (first_name, last_name, birthday, created_at, updated_at)
                VALUES
                  ('Danielle','Michael', DATETIME('1971-07-04'), DATETIME('now'), DATETIME('now')),
                  ('John','Smith', DATETIME('1997-03-01'), DATETIME('now'), DATETIME('now')),
                  ('John','Johnson', DATETIME('1974-07-04'), DATETIME('now'), DATETIME('now'));
                SQL_INSERT_STATEMENT
              )
            end

            it "returns a collection of students matching a given condition" do
              count_of_johns_in_db = $db.get_first_value('SELECT COUNT(*) FROM students WHERE first_name = "John";')

              found_johns = Student.where('first_name = ?', 'John')
              expect(found_johns.count).to eq count_of_johns_in_db
            end

            it "returns a collection of student objects" do
              found_johns = Student.where('first_name = ?', 'John')
              expect(found_johns).to all(be_an_instance_of(Student))
            end
          end
        end

        describe ".all_by_birthday" do
          context 'when there are no students in the database' do
            it 'returns an empty collection' do
              expect(Student.all_by_birthday).to be_empty
            end
          end

          context 'when there are students in the database' do
            # Add student records to the database so that we can retrieve them in our tests.
            before(:each) do
              $db.execute(
                <<-SQL_INSERT_STATEMENT
                INSERT INTO students
                  (first_name, last_name, birthday, created_at, updated_at)
                VALUES
                  ('Danielle','Michael', DATETIME('1971-07-04'), DATETIME('now'), DATETIME('now')),
                  ('Tobin','Larue', DATETIME('1974-07-04'), DATETIME('now'), DATETIME('now'));
                SQL_INSERT_STATEMENT
              )
            end

            it 'returns a collection of student objects' do
              expect(Student.all_by_birthday).to all(be_an_instance_of(Student))
            end

            it 'returns a collection with all the students in it' do
              count_of_students_in_db = $db.get_first_value('SELECT COUNT(*) FROM students;')

              expect(Student.all_by_birthday.length).to eq count_of_students_in_db
            end

            it 'orders students by birthday oldest to youngest' do
              name_of_oldest_student = $db.get_first_value('SELECT first_name FROM students ORDER BY birthday asc LIMIT 1;')
              name_of_youngest_student = $db.get_first_value('SELECT first_name FROM students ORDER BY birthday desc LIMIT 1;')

              students_ordered_by_birthday = Student.all_by_birthday

              expect(students_ordered_by_birthday.first.first_name).to eq name_of_oldest_student
              expect(students_ordered_by_birthday.last.first_name).to eq name_of_youngest_student
            end
          end
        end
      end

      describe 'returning a single student' do
        describe '.find' do
          context 'when no record with the given id is in the database' do
            it 'returns nil' do
              expect(Student.find 0).to be_nil
            end
          end

          context 'when a record with the given id is in the database' do
            # Add a student record to the database so that we can find it in our tests.
            before(:each) do
              $db.execute(
                <<-SQL_INSERT_STATEMENT
                INSERT INTO students
                  (first_name, last_name, birthday, created_at, updated_at)
                VALUES
                  ('Tobin','Larue', DATETIME('1974-07-04'), DATETIME('now'), DATETIME('now'));
                SQL_INSERT_STATEMENT
              )
            end


            let(:tobin_id) { $db.get_first_value('SELECT id FROM students WHERE first_name = "Tobin";') }
            let(:tobin)    { Student.find(tobin_id) }

            it 'returns a student object' do
              expect(tobin).to be_an_instance_of Student
            end

            it 'returns a student with assigned attributes' do
              expect(tobin.id).to eq tobin_id
              expect(tobin.first_name).to eq 'Tobin'
              expect(tobin.last_name).to eq 'Larue'
              expect(tobin.birthday).to match /1974-07-04/
            end
          end
        end

        describe ".find_by_first_name" do
          context 'when no record with the given first name is in the database' do
            it 'returns nil' do
              expect(Student.find_by_first_name 'Sheena').to be_nil
            end
          end

          context 'when a record with the given first name is in the database' do
            # Add a student record to the database so that we can find it in our tests.
            before(:each) do
              $db.execute(
                <<-SQL_INSERT_STATEMENT
                INSERT INTO students
                  (first_name, last_name, birthday, created_at, updated_at)
                VALUES
                  ('Tobin','Larue', DATETIME('1974-07-04'), DATETIME('now'), DATETIME('now'));
                SQL_INSERT_STATEMENT
              )
            end

            it 'returns a student object' do
              tobin = Student.find_by_first_name 'Tobin'
              expect(tobin).to be_an_instance_of Student
            end

            it 'returns a student with the given first name' do
              tobin = Student.find_by_first_name 'Tobin'
              expect(tobin.first_name).to eq 'Tobin'
            end
          end
        end
      end
    end

    describe 'removing data from the database' do
      describe "#delete" do

        # Add a student record to the database so that we have a record to delete.
        before(:each) do
          $db.execute(
            <<-SQL_INSERT_STATEMENT
            INSERT INTO students
              (first_name, last_name, birthday, created_at, updated_at)
            VALUES
              ('Tobin','Larue', DATETIME('1974-07-04'), DATETIME('now'), DATETIME('now'));
            SQL_INSERT_STATEMENT
          )
        end

        it "removes the database record associated with the student from the database" do
          student_count = $db.get_first_value('SELECT COUNT() FROM students')
          expect(student_count).to eq 1

          student_data = $db.execute('SELECT * FROM students LIMIT 1').first
          student = Student.new(student_data)
          student.delete

          updated_student_count = $db.get_first_value('SELECT COUNT() FROM students')
          expect(updated_student_count).to be_zero
        end
      end
    end

    describe "#save" do
      context "record not in the database" do
        let(:unsaved_student) { Student.new(mikee_data) }

        it "saves to the database" do
          expect { unsaved_student.save }.to change { $db.execute("SELECT * FROM students WHERE first_name = ?", 'Mikee').count }.from(0).to(1)
        end

        describe "assigning the id" do
          it "has no id before being saved" do
            expect(unsaved_student.id).to be_nil
          end

          it "is assigned an id after save" do
            unsaved_student.save
            expect(unsaved_student.id).to eq $db.last_insert_row_id
          end
        end
      end

      context "record exists in the database" do
        it "updates the database columns with the attributes of the object" do
          # Get the id of the mikee Ruby object
          mikee_original_id = mikee.id

          # Change the first_name attribute in the Ruby object
          mikee.first_name = "Michael"

          expect { mikee.save }.to change { $db.execute("select * from students where id = ? AND first_name = ?", mikee_original_id, "Michael").count }.from(0).to(1)
        end

        it "does not alter the id" do
          expect { mikee.save }.to_not change { mikee.id }
        end
      end
    end
  end
end
