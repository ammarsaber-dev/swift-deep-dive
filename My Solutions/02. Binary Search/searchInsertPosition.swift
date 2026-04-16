/*
Given a sorted array and a target value, return the index where the target would be inserted to maintain sorted order.

func searchInsert<T: Comparable>(_ nums: [T], _ target: T) -> Int
Example	Input	                     Output
Found	[1, 3, 5, 6], 5	               2
Insert Middle	[1, 3, 5, 6], 2	       1
Insert End	[1, 3, 5, 6], 7	           4
*/

func searchInsert<T: Comparable>(_ nums: [T], _ target: T) -> Int {
    var start = 0
    var end = nums.count

    while start < end {
        let mid = start + (end - start) / 2
        if nums[mid] < target {
            start = mid + 1
        } else {
            end = mid
        }
    }

    return start
}

print(searchInsert([1, 3, 5, 6], 5))  // 2
print(searchInsert([1, 3, 5, 6], 2))  // 1
print(searchInsert([1, 3, 5, 6], 7))  // 4
