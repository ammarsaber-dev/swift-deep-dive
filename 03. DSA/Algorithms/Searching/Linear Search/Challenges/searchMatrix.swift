import Foundation

// Search for a key in a 2D matrix (row-wise sorted)
func searchMatrix(_ matrix: [[Int]], key: Int) -> Bool {
    // TODO: implement
    false
}

// ==================================================================

// MARK: - Tests

func testSearchMatrix() {
    var passed = 0
    var failed = 0

    let matrix = [
        [1, 2, 3],
        [4, 5, 6],
        [7, 8, 9]
    ]

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

    check(searchMatrix(matrix, key: 5), true, "Found in middle")
    check(searchMatrix(matrix, key: 1), true, "Found at start")
    check(searchMatrix(matrix, key: 9), true, "Found at end")
    check(searchMatrix(matrix, key: 10), false, "Not found")
    check(searchMatrix(matrix, key: 0), false, "Below range")
    check(searchMatrix([[1]], key: 1), true, "Single element - found")
    check(searchMatrix([[1]], key: 2), false, "Single element - not found")
    check(searchMatrix([[]], key: 1), false, "Empty matrix")
    check(searchMatrix([[1, 2], [3, 4]], key: 3), true, "2x2 matrix - found")
    check(searchMatrix([[1, 2], [3, 4]], key: 5), false, "2x2 matrix - not found")

    print("\nResults: \(passed) passed, \(failed) failed")
}

testSearchMatrix()
