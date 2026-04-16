/*
Return an array of all indices where the target appears.

func findAll(_ arr: [Int], _ target: Int) -> [Int]
Input	Output
[1, 2, 3, 2, 4], 2	[1, 3]
[1, 2, 3], 5	[]
["a", "a", "a"], "a"	[0, 1, 2]
*/

func findAll<T: Equatable>(_ arr: [T], _ target: T) -> [Int] {
    var indices = [Int]()
    for (index, element) in arr.enumerated() where element == target {
        indices.append(index)
    }

    return indices
}

print(findAll(["a", "a", "a"], "a"))
