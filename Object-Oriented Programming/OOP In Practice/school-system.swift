/*
 =========================================
 Challenge: School Management System
 =========================================

 We need a simple school management system that keeps
 track of students and teachers.

 Both students and teachers are people, they share common
 info like name and age, but each has their own details.

 A student has a grade and a GPA. the GPA must be
 protected, nobody should set it directly from outside.
 it can only be changed through a method that validates
 the new value is between 0.0 and 4.0.

 A teacher has a subject and years of experience.
 a teacher also has a classroom that manages their
 enrolled students, and a teaching license that holds
 a license number and an expiry date.

 A teaching license cannot be created with an empty
 license number or an expired date. use a failable
 initializer to handle this.

 A teacher has a method to check if their license is
 still valid. no subclass should be able to override
 this method.

 Both students and teachers have an abstract method
 role() that returns a String describing who they are.
 the base class should enforce this using fatalError().

 The school keeps a list of all students and teachers
 in a single list. it can enroll a person, expel a
 person by name, and list everyone with their full
 details. when listing, it should be clear whether
 each person is a student or a teacher.

 =========================================
 */
