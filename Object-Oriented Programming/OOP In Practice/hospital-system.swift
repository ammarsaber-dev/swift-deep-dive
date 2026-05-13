/*
 =========================================
 Challenge: Hospital Management System
 =========================================

 We need a simple hospital management system that keeps
 track of patients and doctors.

 Both patients and doctors are people, they share common
 info like name and age, but each has their own details.

 A patient has a diagnosis and a heart rate. the heart
 rate must be protected, nobody should set it directly
 from outside. it can only be changed through a method
 that validates the new value is between 0 and 300.

 A doctor has a specialization and years of experience.
 a doctor also has a schedule that manages their
 appointments, and a medical license that holds a
 license number and an expiry date.

 A medical license cannot be created with an empty
 license number or an expired date. use a failable
 initializer to handle this.

 A doctor has a method to check if their license is
 still valid. no subclass should be able to override
 this method.

 The hospital keeps a list of all patients and doctors
 in a single list. it can admit a person, discharge a
 person by name, and list everyone with their full
 details. when listing, it should be clear whether
 each person is a patient or a doctor.

 =========================================
 */

import Foundation

class Person {
    let name: String
    let age: Int

    func printDetails() {
        print(
            """
            Person Details:
                    Name: \(name)
                    Age: \(age)
            """
        )
    }

    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }
}

class Patient: Person {
    private(set) var diagnosis: String
    private(set) var heartRate: Int

    override func printDetails() {
        print(
            """
            Patient Details:
                    Name: \(name)
                    Age: \(age)
                    Diagnosis: \(diagnosis)
                    heartRate: \(heartRate)
            """
        )
    }

    func updateHeartRate(to newRate: Int) {
        guard newRate >= 0, newRate <= 300 else { return }
        heartRate = newRate
    }

    init(name: String, age: Int, diagnosis: String, heartRate: Int) {
        self.diagnosis = diagnosis
        self.heartRate = heartRate
        super.init(name: name, age: age)
    }
}

class Doctor: Person {
    private let specialization: String
    private let yearsOfExperience: Int

    private let schedule: Schedule
    private let medicalLicense: MedicalLicense

    override func printDetails() {
        print(
            """
            Doctor Details:
                    Name: \(name)
                    Age: \(age)
                    Specialization: \(specialization)
                    Years Of Experience: \(yearsOfExperience)
                    Medical License: \(medicalLicense.licenseNumber)
            """
        )
        schedule.showAllAppointments()
    }

    final func isLicenseValid() -> Bool {
        return medicalLicense.expiryDate > Date()
    }

    init(
        name: String, age: Int, specialization: String, yearsOfExperience: Int, schedule: Schedule,
        medicalLicense: MedicalLicense
    ) {
        self.specialization = specialization
        self.yearsOfExperience = yearsOfExperience
        self.schedule = schedule
        self.medicalLicense = medicalLicense
        super.init(name: name, age: age)
    }
}

class Schedule {
    private(set) var appointments: [String]

    func addNewAppointment(_ appointment: String) {
        appointments.append(appointment)
        print("Added \(appointment) Successfully!")
    }

    func showAllAppointments() {
        guard !appointments.isEmpty else {
            print("No appointments scheduled.")
            return
        }

        print("All appointments:")
        for appointment in appointments {
            print(appointment)
        }
    }

    init(appointments: [String]) {
        self.appointments = appointments
    }
}

class MedicalLicense {
    private(set) var licenseNumber: String
    private(set) var expiryDate: Date

    init?(licenseNumber: String, expiryDate: Date) {
        if licenseNumber.isEmpty || expiryDate < Date() {
            return nil
        }
        self.licenseNumber = licenseNumber
        self.expiryDate = expiryDate
    }
}

class Hospital {
    private let name: String
    private var staff: [Person]

    func admit(person: Person) {
        staff.append(person)
    }

    func discharge(person: Person) {
        if let personIndex = staff.firstIndex(where: { $0.name == person.name }) {
            staff.remove(at: personIndex)
            return
        }

        print("Failed to remove \(person.name).")
    }

    func listStaff() {
        print("All Staff:")
        for staffMember in staff {
            if staffMember is Doctor {
                print("[\(staffMember.name)] - Doctor")
            } else if staffMember is Patient {
                print("[\(staffMember.name)] - Patient")
            }
            staffMember.printDetails()
        }
    }

    init(name: String, staff: [Person]) {
        self.name = name
        self.staff = staff
    }
}

// Testing

// Create a MedicalLicense
let expiryDate = Calendar.current.date(byAdding: .year, value: 1, to: Date())!
let license = MedicalLicense(licenseNumber: "LIC123", expiryDate: expiryDate)!

/// Create a Schedule
let schedule = Schedule(appointments: [])
schedule.addNewAppointment("Monday 10am - John checkup")

/// Create a Doctor
let doctor = Doctor(
    name: "Sarah", age: 45, specialization: "Cardiology", yearsOfExperience: 15, schedule: schedule,
    medicalLicense: license
)

/// Create a Patient
let patient = Patient(name: "John", age: 35, diagnosis: "Flu", heartRate: 80)

/// Create a Hospital
let hospital = Hospital(name: "City Hospital", staff: [])

// Test admit
hospital.admit(person: doctor)
hospital.admit(person: patient)

// Test listStaff
hospital.listStaff()

// Test updateHeartRate
patient.updateHeartRate(to: 95) // valid
patient.updateHeartRate(to: -10) // invalid, should be rejected

// Test isLicenseValid
print(doctor.isLicenseValid()) // true

// Test discharge
hospital.discharge(person: patient)
hospital.discharge(person: patient) // should print "Failed to remove"
