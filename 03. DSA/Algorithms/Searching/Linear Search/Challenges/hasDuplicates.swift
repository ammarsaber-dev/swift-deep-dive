import Foundation

// Check if the array contains duplicates
func hasDuplicates(in arr: [Int]) -> Bool {
    // TODO: implement
    false
}

// ==================================================================

// MARK: - Tests

func testHasDuplicates() {
    var passed = 0
    var failed = 0

    func check(_ result: Bool, _ expected: Bool, _ desc: String) {
        if result == expected {
            print("✅ \(desc)")
            passed += 1
        } else {
            print("❌ \(desc)")
            print("   Expected: \(expected)")
            print("   Got:      \(result)")
            failed += 1
        }
    }

    check(hasDuplicates(in: [1, 2, 3, 4]), false, "No duplicates")
    check(hasDuplicates(in: [1, 2, 2, 4]), true, "Has duplicates")
    check(hasDuplicates(in: [1]), false, "Single element")
    check(hasDuplicates(in: []), false, "Empty array")
    check(hasDuplicates(in: [1, 2, 3, 2, 4]), true, "Duplicates not adjacent")
    check(hasDuplicates(in: [1, 1, 1, 1]), true, "All duplicates")
    check(hasDuplicates(in: [1, 2, 3, 4, 5]), false, "All unique")
    check(hasDuplicates(in: [-1, 2, -1]), true, "Negative numbers")

    print("\nResults: \(passed) passed, \(failed) failed")
}

testHasDuplicates()
