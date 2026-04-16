# Binary Search

#algorithm #searching #array #divide-and-conquer #sorted

> [!contents]+ Contents
> - [[#How It Works]]
> - [[#Performance Complexity]]
> - [[#Implementation]]
> - [[#Challenges]]

Eliminate half of the remaining elements each step by comparing the target with the middle element.

![](https://static.afteracademy.com/images/binary-search-visualization-07b70a40707dc838.gif)


> [!warning]
> **Prerequisite:** Array must be **sorted**

## How It Works

1. Find middle element of sorted array.
2. Compare target with middle:
   - **Equal** → found, return index
   - **Target < Middle** → search left half
   - **Target > Middle** → search right half
3. Repeat until found or search space is empty.

## Performance Complexity

| Case | Time | Space |
|:-----|:-----|:------|
| Best | O(1) | O(1) |
| Worst | O(log n) | O(1) |
| Average | O(log n) | O(1) |

## Implementation

**Iterative** — Time: `O(log n)` | Space: `O(1)`
```swift
func binarySearch(_ arr: [Int], _ key: Int) -> Int? {
    var left = 0
    var right = arr.count - 1

    while left <= right {
        let mid = left + (right - left) / 2

        if arr[mid] == key {
            return mid
        } else if arr[mid] < key {
            left = mid + 1
        } else {
            right = mid - 1
        }
    }
    return nil
}
```

**Recursive** — Time: `O(log n)` | Space: `O(log n)` stack
```swift
func binarySearchRecursive(_ arr: [Int], _ key: Int, _ left: Int = 0, _ right: Int? = nil) -> Int? {
    let end = right ?? arr.count - 1
    guard left <= end else { return nil }

    let mid = left + (end - left) / 2

    if arr[mid] == key {
        return mid
    } else if arr[mid] < key {
        return binarySearchRecursive(arr, key, mid + 1, end)
    } else {
        return binarySearchRecursive(arr, key, left, mid - 1)
    }
}
```

**Built-in** — Time: `O(log n)`
```swift
numbers.firstIndex(where: { $0 >= target })
```

## Challenges

### 1. Guess Number Higher or Lower
`Easy` | [LeetCode 374](https://leetcode.com/problems/guess-number-higher-or-lower/)

Pick a number from 1 to n. Call `guess(num)` which returns: `-1` (picked < num), `1` (picked > num), `0` (correct). Return the picked number.

```swift
func guessNumber(_ n: Int) -> Int
```

| Example | Output |
|:--------|:-------|
| `n = 10, pick = 6` | `6` |
| `n = 1, pick = 1` | `1` |
| `n = 2, pick = 1` | `1` |

> [!info]- Solution 1: Binary Search
> ```swift
> func guessNumber(_ n: Int) -> Int {
>     var left = 1
>     var right = n
>
>     while left <= right {
>         let mid = left + (right - left) / 2
>         let result = guess(mid)
>
>         if result == 0 {
>             return mid
>         } else if result == -1 {
>             right = mid - 1
>         } else {
>             left = mid + 1
>         }
>     }
>     return -1
> }
> ```

> [!info]- Solution 2: Lower Bound
> ```swift
> func guessNumber(_ n: Int) -> Int {
>     var left = 1
>     var right = n
>
>     while left < right {
>         let mid = (left + right) / 2
>         if guess(mid) <= 0 {
>             right = mid
>         } else {
>             left = mid + 1
>         }
>     }
>     return left
> }
> ```

### 2. Search Insert Position
`Easy` | [LeetCode 35](https://leetcode.com/problems/search-insert-position/)

Given sorted array of distinct integers and target, return index if found. If not, return where it would be inserted.

```swift
func searchInsert(_ nums: [Int], _ target: Int) -> Int
```

| Example | Output |
|:--------|:-------|
| `[1,3,5,6], 5` | `2` |
| `[1,3,5,6], 2` | `1` |
| `[1,3,5,6], 7` | `4` |

> [!info]- Solution 1: Binary Search
> ```swift
> func searchInsert(_ nums: [Int], _ target: Int) -> Int {
>     var left = 0
>     var right = nums.count - 1
>
>     while left <= right {
>         let mid = left + (right - left) / 2
>         if nums[mid] == target {
>             return mid
>         } else if nums[mid] < target {
>             left = mid + 1
>         } else {
>             right = mid - 1
>         }
>     }
>     return left
> }
> ```

> [!info]- Solution 2: Lower Bound
> ```swift
> func searchInsert(_ nums: [Int], _ target: Int) -> Int {
>     var left = 0
>     var right = nums.count
>
>     while left < right {
>         let mid = left + (right - left) / 2
>         if nums[mid] < target {
>             left = mid + 1
>         } else {
>             right = mid
>         }
>     }
>     return left
> }
> ```

### 3. Find Minimum in Rotated Array
`Medium` | [LeetCode 153](https://leetcode.com/problems/find-minimum-in-rotated-sorted-array/)

Find minimum element in a rotated sorted array (distinct values).

```swift
func findMin(_ nums: [Int]) -> Int
```

| Example | Output |
|:--------|:-------|
| `[3,4,5,1,2]` | `1` |
| `[4,5,6,7,0,1,2]` | `0` |
| `[1]` | `1` |

> [!info]- Solution 1: Binary Search
> ```swift
> func findMin(_ nums: [Int]) -> Int {
>     var left = 0
>     var right = nums.count - 1
>
>     while left < right {
>         let mid = left + (right - left) / 2
>         if nums[mid] > nums[right] {
>             left = mid + 1
>         } else {
>             right = mid
>         }
>     }
>     return nums[left]
> }
> ```

> [!info]- Solution 2: Linear Scan
> ```swift
> func findMin(_ nums: [Int]) -> Int {
>     var minVal = nums[0]
>     for i in 1..<nums.count {
>         minVal = min(minVal, nums[i])
>     }
>     return minVal
> }
> ```

### 4. Search in Rotated Array
`Medium` | [LeetCode 33](https://leetcode.com/problems/search-in-rotated-sorted-array/)

Search for target in rotated sorted array. Return `true` if found.

```swift
func search(_ nums: [Int], _ target: Int) -> Bool
```

| Example | Output |
|:--------|:-------|
| `[4,5,6,7,0,1,2], 0` | `true` |
| `[4,5,6,7,0,1,2], 3` | `false` |
| `[1], 0` | `false` |

> [!info]- Solution 1: Binary Search
> ```swift
> func search(_ nums: [Int], _ target: Int) -> Bool {
>     var left = 0
>     var right = nums.count - 1
>
>     while left <= right {
>         let mid = left + (right - left) / 2
>         if nums[mid] == target { return true }
>
>         if nums[left] <= nums[mid] {
>             if nums[left] <= target && target < nums[mid] {
>                 right = mid - 1
>             } else {
>                 left = mid + 1
>             }
>         } else {
>             if nums[mid] < target && target <= nums[right] {
>                 left = mid + 1
>             } else {
>                 right = mid - 1
>             }
>         }
>     }
>     return false
> }
> ```

> [!info]- Solution 2: Find Pivot + Binary Search
> ```swift
> func search(_ nums: [Int], _ target: Int) -> Bool {
>     guard !nums.isEmpty else { return false }
>
>     func findPivot() -> Int {
>         var left = 0
>         var right = nums.count - 1
>         while left < right {
>             let mid = left + (right - left) / 2
>             if nums[mid] > nums[right] {
>                 left = mid + 1
>             } else {
>                 right = mid
>             }
>         }
>         return left
>     }
>
>     func binarySearch(_ start: Int, _ end: Int) -> Bool {
>         var l = start
>         var r = end
>         while l <= r {
>             let mid = l + (r - l) / 2
>             if nums[mid] == target { return true }
>             else if nums[mid] < target { l = mid + 1 }
>             else { r = mid - 1 }
>         }
>         return false
>     }
>
>     let pivot = findPivot()
>     if target >= nums[pivot] && target <= nums[nums.count - 1] {
>         return binarySearch(pivot, nums.count - 1)
>     } else {
>         return binarySearch(0, pivot - 1)
>     }
> }
> ```

### 5. Find First and Last Position
`Medium` | [LeetCode 34](https://leetcode.com/problems/find-first-and-last-position-of-element-in-sorted-array/)

Find start and end position of target in sorted array with duplicates.

```swift
func searchRange(_ nums: [Int], _ target: Int) -> [Int]
```

| Example | Output |
|:--------|:-------|
| `[5,7,7,7,7,8,8,10], 7` | `[1,4]` |
| `[5,7,7,8,8,10], 6` | `[-1,-1]` |
| `[1,1,1,1], 1` | `[0,3]` |

> [!info]- Solution 1: Binary Search Twice
> ```swift
> func searchRange(_ nums: [Int], _ target: Int) -> [Int] {
>     func findFirst() -> Int {
>         var left = 0
>         var right = nums.count - 1
>         var result = -1
>         while left <= right {
>             let mid = left + (right - left) / 2
>             if nums[mid] == target {
>                 result = mid
>                 right = mid - 1
>             } else if nums[mid] < target {
>                 left = mid + 1
>             } else {
>                 right = mid - 1
>             }
>         }
>         return result
>     }
>
>     func findLast() -> Int {
>         var left = 0
>         var right = nums.count - 1
>         var result = -1
>         while left <= right {
>             let mid = left + (right - left) / 2
>             if nums[mid] == target {
>                 result = mid
>                 left = mid + 1
>             } else if nums[mid] < target {
>                 left = mid + 1
>             } else {
>                 right = mid - 1
>             }
>         }
>         return result
>     }
>
>     return [findFirst(), findLast()]
> }
> ```

> [!info]- Solution 2: Lower/Upper Bound
> ```swift
> func searchRange(_ nums: [Int], _ target: Int) -> [Int] {
>     func lowerBound(_ target: Int) -> Int {
>         var left = 0
>         var right = nums.count
>         while left < right {
>             let mid = left + (right - left) / 2
>             if nums[mid] < target {
>                 left = mid + 1
>             } else {
>                 right = mid
>             }
>         }
>         return left
>     }
>
>     func upperBound(_ target: Int) -> Int {
>         var left = 0
>         var right = nums.count
>         while left < right {
>             let mid = left + (right - left) / 2
>             if nums[mid] <= target {
>                 left = mid + 1
>             } else {
>                 right = mid
>             }
>         }
>         return left
>     }
>
>     let left = lowerBound(target)
>     if left == nums.count || nums[left] != target {
>         return [-1, -1]
>     }
>     return [left, upperBound(target) - 1]
> }
> ```

### 6. Find Peak Element
`Medium` | [LeetCode 162](https://leetcode.com/problems/find-peak-element/)

Find a peak element (greater than both neighbors). Array ends are not peaks.

```swift
func findPeakElement(_ nums: [Int]) -> Int
```

| Example | Output |
|:--------|:-------|
| `[1,2,3,1]` | `2` |
| `[1,2,1,3,5,6,4]` | `5` |
| `[1]` | `0` |

> [!info]- Solution 1: Binary Search
> ```swift
> func findPeakElement(_ nums: [Int]) -> Int {
>     var left = 0
>     var right = nums.count - 1
>
>     while left < right {
>         let mid = left + (right - left) / 2
>         if nums[mid] < nums[mid + 1] {
>             left = mid + 1
>         } else {
>             right = mid
>         }
>     }
>     return left
> }
> ```

> [!info]- Solution 2: Linear Scan
> ```swift
> func findPeakElement(_ nums: [Int]) -> Int {
>     for i in 0..<(nums.count - 1) {
>         if nums[i] > nums[i + 1] {
>             return i
>         }
>     }
>     return nums.count - 1
> }
> ```

### 7. Search a 2D Matrix
`Medium` | [LeetCode 74](https://leetcode.com/problems/search-a-2d-matrix/)

Search for target in matrix where each row is sorted and row[i+1] > row[i].

```swift
func searchMatrix(_ matrix: [[Int]], _ target: Int) -> Bool
```

| Example | Output |
|:--------|:-------|
| `[[1,3,5,7],[10,11,16,20],[23,30,34,60]], 3` | `true` |
| `[[1,3,5,7],[10,11,16,20],[23,30,34,60]], 13` | `false` |

> [!info]- Solution 1: Binary Search as 1D
> ```swift
> func searchMatrix(_ matrix: [[Int]], _ target: Int) -> Bool {
>     guard !matrix.isEmpty, !matrix[0].isEmpty else { return false }
>     let m = matrix.count
>     let n = matrix[0].count
>     var left = 0
>     var right = m * n - 1
>
>     while left <= right {
>         let mid = left + (right - left) / 2
>         let row = mid / n
>         let col = mid % n
>         if matrix[row][col] == target {
>             return true
>         } else if matrix[row][col] < target {
>             left = mid + 1
>         } else {
>             right = mid - 1
>         }
>     }
>     return false
> }
> ```

> [!info]- Solution 2: Two Binary Searches
> ```swift
> func searchMatrix(_ matrix: [[Int]], _ target: Int) -> Bool {
>     guard !matrix.isEmpty, !matrix[0].isEmpty else { return false }
>
>     func searchCol(_ target: Int) -> Int {
>         var top = 0
>         var bottom = matrix.count - 1
>         while top < bottom {
>             let mid = top + (bottom - top) / 2
>             if matrix[mid][0] <= target {
>                 top = mid + 1
>             } else {
>                 bottom = mid
>             }
>         }
>         return matrix[bottom][0] > target ? bottom - 1 : bottom
>     }
>
>     func searchRow(_ row: Int, _ target: Int) -> Bool {
>         var left = 0
>         var right = matrix[row].count - 1
>         while left <= right {
>             let mid = left + (right - left) / 2
>             if matrix[row][mid] == target {
>                 return true
>             } else if matrix[row][mid] < target {
>                 left = mid + 1
>             } else {
>                 right = mid - 1
>             }
>         }
>         return false
>     }
>
>     let row = searchCol(target)
>     if row < 0 { return false }
>     return searchRow(row, target)
> }
> ```
