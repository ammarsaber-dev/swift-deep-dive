/*
Return how many times the target appears in the array.

func countOccurrences(_ arr: [Int], _ target: Int) -> Int
Input	Output
[1, 2, 3, 2, 4], 2	2
[1, 2, 3], 5	0
["a", "a", "a"], "a"	3
*/

func countOccurrences<T: Equatable>(_ arr: [T], _ target: T) -> Int {
    var counter = 0
    for ele in arr where ele == target {
        counter += 1
    }

    return counter
}

print(countOccurrences([1, 2, 3, 2, 4], 2))  // 2
print(countOccurrences([1, 2, 3], 5))  // 0
print(countOccurrences(["a", "a", "a"], "a"))  // 3
