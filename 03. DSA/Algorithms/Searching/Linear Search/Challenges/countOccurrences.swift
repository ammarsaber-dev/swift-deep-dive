import Foundation

// Count how many times the key appears in the array
func countOccurrences(in arr: [Int], key: Int) -> Int {
    // TODO: implement
    0
}

// ==================================================================

// MARK: - Tests

func testCountOccurrences() {
    var passed = 0
    var failed = 0

    func check(_ result: Int, _ expected: Int, _ desc: String) {
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

    check(countOccurrences(in: [1, 2, 3, 2, 4, 2], key: 2), 3, "Multiple occurrences")
    check(countOccurrences(in: [1, 2, 3, 4, 5], key: 6), 0, "Key not found")
    check(countOccurrences(in: [1], key: 1), 1, "Single element - found")
    check(countOccurrences(in: [1], key: 2), 0, "Single element - not found")
    check(countOccurrences(in: [], key: 1), 0, "Empty array")
    check(countOccurrences(in: [7, 7, 7, 7], key: 7), 4, "All same elements")
    check(countOccurrences(in: [5, 5, 5], key: 3), 0, "No matches")
    check(countOccurrences(in: [1, 2, 3, 4, 5], key: 1), 1, "First element")

    print("\nResults: \(passed) passed, \(failed) failed")
}

testCountOccurrences()
