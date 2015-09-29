class Student
  attr_accessor :first_name, :last_name, :gender, :birthday, :email, :phone
  attr_reader   :id, :created_at, :updated_at

  def initialize(args = {})
    @id         = args['id']
    @first_name = args['first_name']
    @last_name  = args['last_name']
    @gender     = args['gender']
    @birthday   = args['birthday']
    @email      = args['email']
    @phone      = args['phone']
    @created_at = args['created_at']
    @updated_at = args['updated_at']
  end

  def self.find(id)
    where('id = ?', id).first
  end

  def self.find_by_first_name(name)
    where('first_name = ?', name).first
  end

  def self.all
    students_data = $db.execute('select * from students;')
    students_data.map { |data| Student.new(data) }
  end

  def self.where(attribute, value)
    students_data = $db.execute("select * from students where #{attribute}", value)
    students_data.map { |data| Student.new(data) }
  end

  def self.all_by_birthday
    students_data = $db.execute('select * from students order by birthday asc;')
    students_data.map { |data| Student.new(data) }
  end

  def delete
    $db.execute('delete from students where id = ?', self.id)
  end
end
