require 'pry'

class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    new_student = self.new
    new_student.id = row[0]
    new_student.name =  row[1]
    new_student.grade = row[2]
    new_student
  end

  def self.all
    sql = <<-SQL
      SELECT *
      FROM students
    SQL

    DB[:conn].execute(sql).map do |row|
      self.new_from_db(row)
    end
  end

  def self.find_by_name(name)
    self.all.each do |student|
      if student.name == name
       return student
      end
    end
  end

  def self.count_all_students_in_grade_9
    sql = <<-SQL
      SELECT *
      FROM students
    SQL

    new_array = []

    DB[:conn].execute(sql).map do |row|
      new_array << self.new_from_db(row)
    end

    new_array.each do |student|
      if student.grade != "9"
        new_array.pop(student.id)
      end
    end

    new_array
  end

  def self.students_below_12th_grade
    sql = <<-SQL
      SELECT *
      FROM students
    SQL

    new_array = []

    DB[:conn].execute(sql).map do |row|
      new_array << self.new_from_db(row)
    end

    new_array.each do |student|
      if student.grade == "12"
        new_array.pop(student.id)
      end
    end

    new_array
  end

  def self.first_X_students_in_grade_10(x)
    sql = <<-SQL
      SELECT *
      FROM students
    SQL

    student_array = []

    DB[:conn].execute(sql).map do |row|
      student_array << self.new_from_db(row)
    end

    student_array.each do |student|
      if student.grade != "10"
        student_array.pop(student.id)
      end
    end

    i = 1
    new_array = []

    student_array.each do |student|
      while i <= 10
        new_array << student
        i+=1
      end
      binding.pry
    end
    new_array
  end

  def first_student_in_grade_10
  end

  def all_students_in_grade_X(x)
  end

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end
end
