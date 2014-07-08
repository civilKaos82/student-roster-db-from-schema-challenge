require_relative 'student'

describe Student do

  before(:each) do
    $db.transaction
    StudentDB.setup
    StudentDB.seed
  end

  after(:each) do
    $db.rollback
  end

  describe "#save" do

    describe "on a new record" do

      let(:student_data) { {"first_name" => "Mikee",
                            "last_name" => "Pourhadi",
                            "gender" => "Male",
                            "birthday" => "10-25-1985",
                            "email" => "mikeepourhadi@gmail.com",
                            "phone" => "630-363-6640"} }

      let(:student) { Student.new(student_data) }

      it "updates the id after saving" do
        expect(student.id).to be_nil
        student.save
        expect(student.id).not_to be_nil
      end
    end

    describe "on an existing record" do

      let(:student) { Student.find(1) }

      it "updates the other columns" do
        expect(student.first_name).to eq("Alyssa")
        student.first_name = "Michelle"
        student.save
        expect(student.first_name).to eq("Michelle")
      end
    end
  end

  describe "#find" do
    it "allows me to find a unique student" do
      found_student = Student.find(1)
      expect(found_student).to be_a Student
      expect(found_student.first_name).to eq("Alyssa")
    end
  end

  describe "#delete" do
    it "deletes a student" do
      student = Student.find(1)
      expect(student.delete).to be_true
    end
  end

  describe "#all" do
    it "retrieves all students at once" do
      expect(Student.all.size).to eq(6)
      expect(Student.all.first).to be_a(Student)
    end

  end

  describe "#find_by_first_name" do
    it "retrieves students based on first name" do
      students = Student.find_by_first_name("Matt")
      expect(students.size).to eq(2)
      expect(students.first).to be_a(Student)
    end
  end

  describe "#where" do
    it "retrieves students by any attribute" do
      students = Student.where("last_name = ?", "Baker")
      expect(students.size).to eq(1)
      expect(students.first).to be_a(Student)
    end
  end

  describe "#all_by_birthday" do
    it "orders students by birthday oldest to youngest" do
      expect(Student.all_by_birthday.first.first_name).to eq("Brick")
    end
  end
end