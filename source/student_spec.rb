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

  let(:mikee_2_data) do
    { "first_name" => "Mikee",
      "last_name"  => "Baker",
      "gender"     => "Male",
      "birthday"   => "1987-11-05",
      "email"      => "matt@devbootcamp.com",
      "phone"      => "503-333-7740" }
  end


  describe "#save" do
    context "record not in the database" do

      let(:student) { Student.new(mikee_data) }

      it "saves to the database" do
        expect { student.save }.to change { $db.execute("SELECT * FROM students WHERE first_name = ?", 'Mikee').count }.from(0).to(1)
      end

      it "assign the id created by the database to the object" do
        expect { student.save }.to change { student.id }.from(nil).to( $db.last_insert_row_id )
      end
    end

    context "record exists in the database" do
      let(:student) do
        mikee = Student.new(mikee_data)
        mikee.save
        mikee
      end

      it "updates the database columns with the attributes of the object" do
        # Change the first_name attribute in the Ruby object
        student.first_name = "Michael"

        expect { student.save }.to change { $db.execute("select * from students where first_name = ?", 'Michael').count }.from(0).to(1)
      end
    end
  end

  describe "#find" do
    before :each do
      @student = Student.new(mikee_data)
      @student.save
    end

    it "allows me to find a unique student" do
      found_student = Student.find(@student.id)
      expect(found_student).to be_a Student
      expect(found_student.first_name).to eq("Mikee")
    end
  end

  describe "#delete" do
    before :each do
      @student = Student.new(mikee_data)
      @student.save
    end

    it "deletes a student" do
      student = Student.find(@student.id)
      expect(student).to be_a Student

      student.delete
      expect(Student.find(@student.id)).to be(nil)
    end
  end

  describe "#all" do
    before :each do
      @student = Student.new(mikee_data)
      @student.save
    end

    it "retrieves all students at once" do
      student_count = $db.execute("SELECT * FROM students").length
      expect(Student.all.size).to eq(student_count)
      expect(Student.all.first).to be_a(Student)
    end

  end

  describe "#find_by_first_name" do
    before :each do
      Student.new(mikee_data).save
      Student.new(mikee_2_data).save
    end

    it "retrieves students based on first name" do
      students = Student.find_by_first_name("Mikee")
      expect(students.size).to eq(2)
      expect(students.first).to be_a(Student)
      expect(students[1].last_name).to eq("Baker")
    end
  end

  describe "#where" do
    before :each do
      Student.new(mikee_data).save
    end

    it "retrieves students by any attribute" do
      students = Student.where("last_name = ?", "Pourhadi")
      expect(students.size).to eq(1)
      expect(students.first).to be_a(Student)
    end
  end

  describe "#all_by_birthday" do
    before :each do
      Student.new(mikee_data).save
      Student.new(mikee_2_data).save
    end

    it "orders students by birthday oldest to youngest" do
      expect(Student.all_by_birthday[0].last_name).to eq("Pourhadi")
      expect(Student.all_by_birthday[1].last_name).to eq("Baker")
    end
  end
end
