/*
Return the index of the minimum element.

func findMin<T: Comparable>(_ arr: [T]) -> Int
Input	          Output
[3, 1, 4, 1, 5]	    1
[5]	                0
[1, 2, 3]	        0
*/

// func findMin<T: Comparable>(_ arr: [T]) -> Int {
//     var m = 0
//     for i in 0..<arr.count {
//         if arr[m] > arr[i] {
//             m = i
//         }
//     }
//     return m
// }

func findMin<T: Comparable>(_ arr: [T]) -> Int {
    guard let minValue = arr.min() else { return -1 }
    return arr.firstIndex(of: minValue) ?? -1
}

print(findMin([3, 1, 4, 1, 5]))  // 1
print(findMin([5]))  // 0
print(findMin([1, 2, 3]))  // 0
