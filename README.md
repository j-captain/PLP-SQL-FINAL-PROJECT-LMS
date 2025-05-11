# Learning Management System (LMS) Database

 *Example ERD *
 <img width="376" alt="lms" src="https://github.com/user-attachments/assets/bb96ff1a-c99e-42ab-af70-a21a022e6bd7" />


## Project Description
A robust SQL database solution for managing all aspects of a modern learning management system. This database handles:

- **User management** with role-based access (Admins/Teachers/Students)
- **Course lifecycle** from creation to scheduling
- **Academic operations** including assignments, quizzes, and grading
- **Student enrollment** and progress tracking
- **Secure authentication** system with password hashing

## Key Features
- **Role-based Access Control**
  - Admins: Full system control
  - Teachers: Course/content management
  - Students: Course participation
- **Academic Management**
  - Course catalog with credit hours
  - Class scheduling with time slots
  - Assignment and quiz systems
- **Tracking System**
  - Student enrollment records
  - Assignment submissions tracking
  - Quiz results logging

## Technology Stack
- **Database**: MySQL 8.0+
- **Storage Engine**: InnoDB
- **Security**: SHA-256 password hashing
- **Compatibility**: UTF8MB4 character set

## Database Structure
### Core Tables
| Table Name          | Description                          |
|---------------------|--------------------------------------|
| `users`             | User accounts with roles             |
| `courses`           | Course catalog information           |
| `classes`           | Scheduled course instances           |
| `enrollments`       | Student enrollment records           |

### Assessment System
| Table Name          | Description                          |
|---------------------|--------------------------------------|
| `assignments`       | Course assignments                   |
| `submissions`       | Student work submissions             |
| `quizzes`           | Quiz definitions                     |
| `quiz_questions`    | Quiz content storage                 |

## Setup Instructions

### Prerequisites
- MySQL Server 8.0+
- MySQL Command Line Client

### Installation Steps
1. **Create Database**
`bash
mysql -u root -p -e "CREATE DATABASE lms CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"

Import SQL Structure
bash
mysql -u root -p lms < lms_database.sql

Connect to Database
'bash
mysql -u your_username -p lms

**Sample Queries**

 Find all courses taught by a teacher:
    SELECT * FROM courses WHERE teacher_id = {teacher_id};

Get student enrollments:
    SELECT users.first_name, courses.course_name 
    FROM enrollments
    JOIN users ON enrollments.student_id = users.user_id
    JOIN classes ON enrollments.class_id = classes.class_id
    JOIN courses ON classes.course_id = courses.course_id;

**Security Configuration**
sql

-- Create roles
CREATE ROLE 'lms_admin', 'lms_teacher', 'lms_student';

-- Admin privileges
GRANT ALL PRIVILEGES ON lms.* TO 'lms_admin';

-- Teacher privileges
GRANT SELECT, INSERT, UPDATE ON assignments TO 'lms_teacher';

-- Student privileges
GRANT SELECT, INSERT ON submissions TO 'lms_student';

**ERD Documentation**

Our Entity Relationship Diagram illustrates the database structure:
LMS ERD Diagram (Replace with actual ERD image)

**Key Relationships:**

    users → courses (Teacher-course relationship)
    classes → enrollments (Class enrollment tracking)
    assignments → submissions (Assignment workflow)
    quizzes → quiz_submissions (Assessment system)

**Recommended Tools for ERD Creation:**

    1.MySQL Workbench (Reverse Engineering)
    2.Draw.io
