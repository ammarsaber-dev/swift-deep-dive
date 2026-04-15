import Foundation

// Find the index of the smallest element
func findMinIndex(in arr: [Int]) -> Int? {
    // TODO: implement
    nil
}

// ==================================================================

// MARK: - Tests

func testFindMinIndex() {
    var passed = 0
    var failed = 0

    func check(_ result: Int?, _ expected: Int?, _ desc: String) {
        if result == expected {
            print("✅ \(desc)")
            passed += 1
        } else {
            print("❌ \(desc)")
            print("   Expected: \(String(describing: expected))")
            print("   Got:      \(String(describing: result))")
            failed += 1
        }
    }

    check(findMinIndex(in: [5, 3, 8, 1, 4]), 3, "Min in middle")
    check(findMinIndex(in: [1, 2, 3, 4, 5]), 0, "Min at start")
    check(findMinIndex(in: [5, 4, 3, 2, 1]), 4, "Min at end")
    check(findMinIndex(in: [7]), 0, "Single element")
    check(findMinIndex(in: []), nil, "Empty array")
    check(findMinIndex(in: [3, 3, 3, 1, 3]), 3, "Min has duplicates")
    check(findMinIndex(in: [-5, -2, -8, -1, -3]), 2, "Negative numbers")

    print("\nResults: \(passed) passed, \(failed) failed")
}

testFindMinIndex()
