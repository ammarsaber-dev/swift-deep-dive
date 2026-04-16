/*
Return true if the target exists in the array.

func exists<T: Equatable>(_ arr: [T], _ target: T) -> Bool
Input	Output
[1, 2, 3], 2	true
[1, 2, 3], 5	false
["a", "b"], "c"	false
*/

func exists<T: Equatable>(_ arr: [T], _ target: T) -> Bool {
    for ele in arr where ele == target {
        return true
    }

    return false
}

print(exists([1, 2, 3], 2))
print(exists([1, 2, 3], 5))
print(exists(["a", "b"], "c"))
