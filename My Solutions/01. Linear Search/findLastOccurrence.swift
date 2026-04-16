/*
Return the index of the last occurrence of the target.

func findLast<T: Equatable>(_ arr: [T], _ target: T) -> Int?
Input	Output
[1, 2, 3, 2, 4], 2	3
[1, 2, 3], 5	nil
["a"], "a"	0
*/

// func findLast<T: Equatable>(_ arr: [T], _ target: T) -> Int? {
//     guard !arr.isEmpty else { return nil }

//     var lastIndex: Int?
//     for (index, element) in arr.enumerated() where element == target {
//         lastIndex = index
//     }

//     return lastIndex
// }

func findLast<T: Equatable>(_ arr: [T], _ target: T) -> Int? {
    guard !arr.isEmpty else { return nil }

    for (index, element) in arr.enumerated().reversed() where element == target {
        return index
    }

    return nil
}

print(findLast([1, 2, 3, 2, 4], 2) as Any)  // 3
print(findLast([1, 2, 3], 5) as Any)  // nil
print(findLast(["a"], "a") as Any)  // 0
