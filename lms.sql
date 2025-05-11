-- Learning Management System (LMS) Database
-- Created: 11th May 2025 at 1027Hrs
-- Description: This SQL script sets up a basic Learning Management System (LMS) database schema.
-- Author: Mwangi Josphat Karanja

-- Create Database
CREATE DATABASE IF NOT EXISTS `lms` 
DEFAULT CHARACTER SET utf8mb4 
COLLATE utf8mb4_general_ci;

USE `lms`;

 
-- CORE TABLES
 
-- Users Table with Roles
CREATE TABLE `users` (
  `user_id` INT PRIMARY KEY AUTO_INCREMENT,
  `username` VARCHAR(50) UNIQUE NOT NULL,
  `password` VARCHAR(255) NOT NULL,
  `first_name` VARCHAR(50) NOT NULL,
  `last_name` VARCHAR(50) NOT NULL,
  `role` ENUM('admin','teacher','student') NOT NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

 
-- ACADEMIC STRUCTURE

-- Courses Table
CREATE TABLE `courses` (
  `course_id` INT PRIMARY KEY AUTO_INCREMENT,
  `course_code` VARCHAR(20) UNIQUE NOT NULL,
  `course_name` VARCHAR(100) NOT NULL,
  `description` TEXT,
  `credit_hours` INT NOT NULL,
  `teacher_id` INT,
  FOREIGN KEY (`teacher_id`) REFERENCES `users`(`user_id`)
) ENGINE=InnoDB;

-- Classes Table (Course Instances)
CREATE TABLE `classes` (
  `class_id` INT PRIMARY KEY AUTO_INCREMENT,
  `course_id` INT NOT NULL,
  `schedule` VARCHAR(50) NOT NULL,
  `start_date` DATE NOT NULL,
  `end_date` DATE NOT NULL,
  FOREIGN KEY (`course_id`) REFERENCES `courses`(`course_id`)
) ENGINE=InnoDB;

 
-- ENROLLMENT SYSTEM
 
-- Enrollments Table
CREATE TABLE `enrollments` (
  `enrollment_id` INT PRIMARY KEY AUTO_INCREMENT,
  `class_id` INT NOT NULL,
  `student_id` INT NOT NULL,
  `enrollment_date` DATE NOT NULL,
  FOREIGN KEY (`class_id`) REFERENCES `classes`(`class_id`),
  FOREIGN KEY (`student_id`) REFERENCES `users`(`user_id`)
) ENGINE=InnoDB;

 
-- ASSESSMENT SYSTEM
 
-- Assignments Table
CREATE TABLE `assignments` (
  `assignment_id` INT PRIMARY KEY AUTO_INCREMENT,
  `class_id` INT NOT NULL,
  `title` VARCHAR(100) NOT NULL,
  `description` TEXT,
  `due_date` DATETIME NOT NULL,
  `max_score` INT NOT NULL,
  FOREIGN KEY (`class_id`) REFERENCES `classes`(`class_id`)
) ENGINE=InnoDB;

-- Submissions Table
CREATE TABLE `submissions` (
  `submission_id` INT PRIMARY KEY AUTO_INCREMENT,
  `assignment_id` INT NOT NULL,
  `student_id` INT NOT NULL,
  `submitted_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `file_path` VARCHAR(255),
  `score` INT,
  FOREIGN KEY (`assignment_id`) REFERENCES `assignments`(`assignment_id`),
  FOREIGN KEY (`student_id`) REFERENCES `users`(`user_id`)
) ENGINE=InnoDB;


-- QUIZ SYSTEM

-- Quizzes Table
CREATE TABLE `quizzes` (
  `quiz_id` INT PRIMARY KEY AUTO_INCREMENT,
  `class_id` INT NOT NULL,
  `title` VARCHAR(100) NOT NULL,
  `description` TEXT,
  `time_limit` INT,
  FOREIGN KEY (`class_id`) REFERENCES `classes`(`class_id`)
) ENGINE=InnoDB;

-- Quiz Questions Table
CREATE TABLE `quiz_questions` (
  `question_id` INT PRIMARY KEY AUTO_INCREMENT,
  `quiz_id` INT NOT NULL,
  `question_text` TEXT NOT NULL,
  `question_type` ENUM('multiple_choice','true_false','short_answer') NOT NULL,
  `correct_answer` TEXT NOT NULL,
  FOREIGN KEY (`quiz_id`) REFERENCES `quizzes`(`quiz_id`)
) ENGINE=InnoDB;

-- Quiz Answers Table
CREATE TABLE `quiz_answers` (
  `answer_id` INT PRIMARY KEY AUTO_INCREMENT,
  `question_id` INT NOT NULL,
  `answer_text` TEXT NOT NULL,
  `is_correct` BOOLEAN DEFAULT FALSE,
  FOREIGN KEY (`question_id`) REFERENCES `quiz_questions`(`question_id`)
) ENGINE=InnoDB;

-- Quiz Submissions Table
CREATE TABLE `quiz_submissions` (
  `submission_id` INT PRIMARY KEY AUTO_INCREMENT,
  `quiz_id` INT NOT NULL,
  `student_id` INT NOT NULL,
  `submitted_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `score` INT,
  FOREIGN KEY (`quiz_id`) REFERENCES `quizzes`(`quiz_id`),
  FOREIGN KEY (`student_id`) REFERENCES `users`(`user_id`)
) ENGINE=InnoDB;

 
-- SAMPLE DATA
 
-- Insert Sample Users
INSERT INTO `users` (`username`, `password`, `first_name`, `last_name`, `role`) VALUES
('admin1', SHA2('adminpass', 256), 'John', 'Doe', 'admin'),
('teacher1', SHA2('teacherpass', 256), 'Alice', 'Smith', 'teacher'),
('student1', SHA2('studentpass', 256), 'Emma', 'Wilson', 'student');

-- Insert Sample Courses
INSERT INTO `courses` (`course_code`, `course_name`, `credit_hours`, `teacher_id`) VALUES
('MATH101', 'Calculus I', 4, 2),
('ENG101', 'English Composition', 3, 2);

-- Insert Sample Classes
INSERT INTO `classes` (`course_id`, `schedule`, `start_date`, `end_date`) VALUES
(1, 'MWF 10:00-11:00', '2024-09-01', '2024-12-15');

-- Insert Sample Enrollments
INSERT INTO `enrollments` (`class_id`, `student_id`, `enrollment_date`) VALUES
(1, 3, '2024-08-25');

 
-- SECURITY SETUP
 
-- Create Application Roles
CREATE ROLE IF NOT EXISTS 
  'lms_admin', 
  'lms_teacher', 
  'lms_student';

-- Grant Privileges
GRANT ALL PRIVILEGES ON lms.* TO 'lms_admin';
GRANT SELECT, INSERT, UPDATE ON lms.assignments TO 'lms_teacher';
GRANT SELECT, INSERT ON lms.submissions TO 'lms_student';

-- Create Users
CREATE USER 'admin_user'@'localhost' IDENTIFIED BY 'SecureAdminPass123!';
CREATE USER 'teacher_user'@'localhost' IDENTIFIED BY 'TeacherPass456!';
CREATE USER 'student_user'@'localhost' IDENTIFIED BY 'StudentPass789!';

-- Assign Roles
GRANT 'lms_admin' TO 'admin_user'@'localhost';
GRANT 'lms_teacher' TO 'teacher_user'@'localhost';
GRANT 'lms_student' TO 'student_user'@'localhost';

FLUSH PRIVILEGES;
