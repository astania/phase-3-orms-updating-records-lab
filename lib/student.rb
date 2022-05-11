require_relative "../config/environment.rb"

class Student

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]
  attr_accessor :name, :grade
  attr_reader :id

def initialize (id=nil, name, grade)
  @id = id 
  @name = name
  @grade = grade
end 

  def self.create_table 
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY, 
      name TEXT,
      grade INTEGER
    )
    SQL

    DB[:conn].execute(sql)
  end 

def self.drop_table
  sql = <<-SQL 
    DROP TABLE IF EXISTS students
    SQL

  DB[:conn].execute(sql)
end 

def update 
  sql = "UPDATE students SET name = ?, grade = ? WHERE id = ?"
  DB[:conn].execute(sql, self.name, self.grade, self.id)
end 

def save
  if self.id
    self.update
  else 
  sql = <<-SQL 
    INSERT INTO students (name, grade)
    VALUES (?, ?)
    SQL
  
    DB[:conn].execute(sql, self.name, self.grade)
    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
  end 
end 

def self.create(name, grade)
  new_student = Student.new(name, grade)
  new_student.save
end 

def self.new_from_db (array)
  Student.new(array[0], array[1], array[2])
end 

def self.find_by_name(student_name)
  sql = "SELECT * FROM students WHERE name = ?"

  result = DB[:conn].execute(sql, student_name)[0]

  new_from_db(result)

end 

end 














#   def initialize(id=nil, name, grade)
#     @id = id
#     @name = name
#     @grade = grade
#   end 

#   def self.create_table 
#     sql = <<-SQL
#     CREATE TABLE IF NOT EXISTS students (
#       id INTEGER PRIMARY KEY, 
#       name TEXT,
#       grade INTEGER
#     )
#     SQL

#     DB[:conn].execute(sql)
#   end 

#   def self.drop_table
#     sql = <<-SQL 
#     DROP TABLE IF EXISTS students
#     SQL

#     DB[:conn].execute(sql)
#   end 

#   def update 
#     sql = "UPDATE students SET name = ?, grade = ? WHERE id = ?"
#     DB[:conn].execute(sql, self.name, self.grade, self.id)
#   end 

#   def save

#     if self.id
#       self.update
#     else 
#     sql = <<-SQL
#       INSERT INTO students (name, grade)
#       VALUES (?,?)
#       SQL

#       DB[:conn].execute(sql, self.name, self.grade)
#       @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
#     end 
#   end 

#   def self.create(name, grade)
#     student = Student.new(name, grade)
#     student.save
#     student 
#   end 

#   def self.new_from_db(query_array)
#     student = Student.new(query_array[0], query_array[1], query_array[2])
#     student 
#   end 

#   def self.find_by_name(name)
#     sql = "SELECT * from students WHERE name = ?"
#     result = DB[:conn].execute(sql, name)[0]
#     Student.new(result[0], result[1], result[2])
#   end 



# end
