/*
Return the index of the target, or nil if not found.

func linearSearch(_ arr: [Int], _ target: Int) -> Int?
Input	Output
[1, 2, 3, 4, 5], 3	2
[1, 2, 3, 4, 5], 6	nil
["a", "b", "c"], "b"	1
*/

func linearSearch<T: Equatable>(_ arr: [T], _ target: T) -> Int? {
    guard !arr.isEmpty else { return nil }

    for (index, element) in arr.enumerated() where element == target {
        return index
    }

    return nil
}

if let index = linearSearch([1, 2, 3, 4, 5], 3) {
    print(index)  // 2
}

print(linearSearch([1, 2, 3, 4, 5], 6) as Any)  // nil

if let index = linearSearch(["a", "b", "c"], "b") {
    print(index)  // 1
}
