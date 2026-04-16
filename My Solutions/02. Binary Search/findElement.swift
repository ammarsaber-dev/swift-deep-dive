/*
Given a sorted array and a target value, return the index of the target, or nil if not found.

func binarySearch<T: Comparable>(_ arr: [T], _ target: T) -> Int?
Example	Input	Output
Basic	[1, 3, 5, 7, 9], 7	3
Not Found	[1, 3, 5, 7, 9], 4	nil
String	["a", "c", "e"], "c"	1
*/

func binarySearch<T: Comparable>(_ arr: [T], _ target: T) -> Int? {
    var start = 0
    var end = arr.count - 1

    while start <= end {
        let mid = start + (end - start) / 2
        if arr[mid] == target {
            return mid
        } else if arr[mid] < target {
            start = mid + 1
        } else {
            end = mid - 1
        }
    }

    return nil
}

print(binarySearch([1, 3, 5, 7, 9], 7) as Any)  // 3
print(binarySearch([1, 3, 5, 7, 9], 4) as Any)  // 4
print(binarySearch(["a", "c", "e"], "c") as Any)  // 1
