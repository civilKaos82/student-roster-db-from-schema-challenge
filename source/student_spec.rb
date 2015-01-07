require_relative 'student'

describe Student do

  before(:each) do
    $db.transaction
    $db.execute("DELETE FROM students")
  end

  after(:each) do
    $db.rollback
  end

  let(:mikee_data) do
    { "first_name" => "Mikee",
      "last_name"  => "Pourhadi",
      "gender"     => "Male",
      "birthday"   => "1985-10-25",
      "email"      => "mikeepourhadi@gmail.com",
      "phone"      => "630-363-6640" }
  end

  let(:mikee) do
    mikee = Student.new(mikee_data)
    mikee.save
    mikee
  end

  let(:mikee_2_data) do
    { "first_name" => "Mikee",
      "last_name"  => "Baker",
      "gender"     => "Male",
      "birthday"   => "1987-11-05",
      "email"      => "matt@devbootcamp.com",
      "phone"      => "503-333-7740" }
  end

  let(:other_mikee) do
    student = Student.new(mikee_2_data)
    student.save
    student
  end


  describe "#save" do
    context "record not in the database" do
      let(:unsaved_student) { Student.new(mikee_data) }

      it "saves to the database" do
        expect { unsaved_student.save }.to change { $db.execute("SELECT * FROM students WHERE first_name = ?", 'Mikee').count }.from(0).to(1)
      end

      it "assign the id created by the database to the object" do
        expect { unsaved_student.save }.to change { unsaved_student.id }.from(nil).to( $db.last_insert_row_id )
      end
    end

    context "record exists in the database" do
      it "updates the database columns with the attributes of the object" do
        # Change the first_name attribute in the Ruby object
        mikee.first_name = "Michael"

        expect { mikee.save }.to change { $db.execute("select * from students where first_name = ?", 'Michael').count }.from(0).to(1)
      end
    end
  end

  describe ".find" do
    it "returns a student" do
      found_student = Student.find(mikee.id)
      expect(found_student).to be_a Student
    end

    it "allows me to find a unique student by id" do
      found_student = Student.find(mikee.id)
      expect(found_student.first_name).to eq mikee.first_name
    end
  end

  describe "#delete" do
    it "deletes a student" do
      found_student = Student.find(mikee.id)
      expect(found_student).to be_a Student

      found_student.delete
      expect(Student.find(mikee.id)).to be(nil)
    end
  end

  describe ".all" do
    it "retrieves all students at once" do
      saved_students = [mikee, other_mikee]

      student_count = $db.execute("SELECT * FROM students").length
      expect(Student.all.size).to eq(student_count)
      expect(Student.all.first).to be_a(Student)
    end

  end

  describe ".find_by_first_name" do
    it "retrieves students based on first name" do
      expected_students = [mikee, other_mikee]
      found_students = Student.find_by_first_name("Mikee")

      expect(found_students.size).to eq expected_students.size
      expect(found_students.first).to be_a Student
      expect(found_students[1].last_name).to eq "Baker"
    end
  end

  describe ".where" do
    it "retrieves students by any attribute" do
      students = Student.where("last_name = ?", mikee.last_name)
      expect(students.size).to eq(1)
      expect(students.first).to be_a(Student)
    end
  end

  describe ".all_by_birthday" do
    it "orders students by birthday oldest to youngest" do
      students_ordered_by_birthday = [mikee, other_mikee].sort_by(&:birthday)

      expect(Student.all_by_birthday[0].last_name).to eq students_ordered_by_birthday[0].last_name
      expect(Student.all_by_birthday[1].last_name).to eq students_ordered_by_birthday[1].last_name
    end
  end
end
