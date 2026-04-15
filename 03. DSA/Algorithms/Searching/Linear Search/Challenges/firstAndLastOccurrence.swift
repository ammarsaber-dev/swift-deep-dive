import Foundation

// Find the first and last occurrence of key in a sorted array with duplicates
func findFirstAndLast(in arr: [Int], key: Int) -> (first: Int, last: Int)? {
    // TODO: implement
    nil
}

// ==================================================================

// MARK: - Tests

func testFindFirstAndLast() {
    var passed = 0
    var failed = 0

    func check(_ result: (first: Int, last: Int)?, _ expected: (first: Int, last: Int)?, _ desc: String) {
        let isMatch: Bool
        if let r = result, let e = expected {
            isMatch = r.first == e.first && r.last == e.last
        } else {
            isMatch = result == nil && expected == nil
        }

        if isMatch {
            print("✅ \(desc)")
            passed += 1
        } else {
            print("❌ \(desc)")
            print("   Expected: \(String(describing: expected))")
            print("   Got:      \(String(describing: result))")
            failed += 1
        }
    }

    check(findFirstAndLast(in: [1, 2, 2, 2, 3, 4], key: 2), (1, 3), "Multiple occurrences")
    check(findFirstAndLast(in: [1, 2, 3, 4, 5], key: 3), (2, 2), "Single occurrence")
    check(findFirstAndLast(in: [1, 2, 3, 4, 5], key: 6), nil, "Key not found")
    check(findFirstAndLast(in: [5], key: 5), (0, 0), "Single element - found")
    check(findFirstAndLast(in: [5], key: 3), nil, "Single element - not found")
    check(findFirstAndLast(in: [], key: 1), nil, "Empty array")
    check(findFirstAndLast(in: [2, 2, 2, 2], key: 2), (0, 3), "All same elements")
    check(findFirstAndLast(in: [1, 3, 5, 7, 9], key: 1), (0, 0), "Key at start")
    check(findFirstAndLast(in: [1, 3, 5, 7, 9], key: 9), (4, 4), "Key at end")

    print("\nResults: \(passed) passed, \(failed) failed")
}

testFindFirstAndLast()
