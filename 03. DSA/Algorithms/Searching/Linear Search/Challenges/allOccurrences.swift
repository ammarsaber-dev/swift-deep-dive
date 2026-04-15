import Foundation

// Find all indices where the key exists in the array
func findAllOccurrences(in arr: [Int], key: Int) -> [Int] {
    // TODO: implement
    []
}

// ==================================================================

// MARK: - Tests

func testFindAllOccurrences() {
    var passed = 0
    var failed = 0

    func check(_ result: [Int], _ expected: [Int], _ desc: String) {
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

    check(findAllOccurrences(in: [1, 2, 3, 2, 4, 2], key: 2), [1, 3, 5], "Multiple occurrences")
    check(findAllOccurrences(in: [1, 2, 3, 4, 5], key: 6), [], "Key not found")
    check(findAllOccurrences(in: [1], key: 1), [0], "Single element - found")
    check(findAllOccurrences(in: [1], key: 2), [], "Single element - not found")
    check(findAllOccurrences(in: [], key: 1), [], "Empty array")
    check(findAllOccurrences(in: [7, 7, 7, 7], key: 7), [0, 1, 2, 3], "All same elements")
    check(findAllOccurrences(in: [1, 2, 1, 2, 1], key: 1), [0, 2, 4], "Alternating pattern")

    print("\nResults: \(passed) passed, \(failed) failed")
}

testFindAllOccurrences()
