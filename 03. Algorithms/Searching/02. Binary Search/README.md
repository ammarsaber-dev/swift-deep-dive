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

### 1. Find Element
Return the index of the target in a sorted array, or `nil` if not found.

```swift
func binarySearch<T: Comparable>(_ arr: [T], _ target: T) -> Int?
```

| Input | Output |
|:------|:-------|
| `[1, 3, 5, 7, 9], 7` | `3` |
| `[1, 3, 5, 7, 9], 4` | `nil` |
| `["a", "c", "e"], "c"` | `1` |

> [!info]- Solution 1: Iterative
> ```swift
> func binarySearch<T: Comparable>(_ arr: [T], _ target: T) -> Int? {
>     var left = 0
>     var right = arr.count - 1
>
>     while left <= right {
>         let mid = left + (right - left) / 2
>         if arr[mid] == target {
>             return mid
>         } else if arr[mid] < target {
>             left = mid + 1
>         } else {
>             right = mid - 1
>         }
>     }
>     return nil
> }
> ```

> [!info]- Solution 2: Recursive
> ```swift
> func binarySearchRecursive<T: Comparable>(_ arr: [T], _ target: T, _ left: Int = 0, _ right: Int? = nil) -> Int? {
>     let end = right ?? arr.count - 1
>     guard left <= end else { return nil }
>
>     let mid = left + (end - left) / 2
>
>     if arr[mid] == target {
>         return mid
>     } else if arr[mid] < target {
>         return binarySearchRecursive(arr, target, mid + 1, end)
>     } else {
>         return binarySearchRecursive(arr, target, left, mid - 1)
>     }
> }
> ```

> [!info]- Solution 3: Built-in
> ```swift
> arr.firstIndex(where: { $0 >= target })
> ```

### 2. Search Insert Position
Return the index where target would be inserted in a sorted array.

```swift
func searchInsert<T: Comparable>(_ nums: [T], _ target: T) -> Int
```

| Input | Output |
|:------|:-------|
| `[1, 3, 5, 6], 5` | `2` |
| `[1, 3, 5, 6], 2` | `1` |
| `[1, 3, 5, 6], 7` | `4` |

> [!info]- Solution 1: Binary Search
> ```swift
> func searchInsert<T: Comparable>(_ nums: [T], _ target: T) -> Int {
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

> [!info]- Solution 2: Built-in
> ```swift
> nums.firstIndex(where: { $0 >= target }) ?? nums.count
> ```

### 3. Find First Occurrence
Return the index of the first occurrence of target in a sorted array with duplicates.

```swift
func findFirst<T: Comparable>(_ arr: [T], _ target: T) -> Int?
```

| Input | Output |
|:------|:-------|
| `[1, 2, 3, 3, 3, 4], 3` | `2` |
| `[1, 2, 3, 3, 3, 4], 5` | `nil` |
| `[1, 2, 3, 4], 1` | `0` |

> [!info]- Solution 1: Search Left
> ```swift
> func findFirst<T: Comparable>(_ arr: [T], _ target: T) -> Int? {
>     var left = 0
>     var right = arr.count - 1
>     var result: Int?
>
>     while left <= right {
>         let mid = left + (right - left) / 2
>         if arr[mid] == target {
>             result = mid
>             right = mid - 1
>         } else if arr[mid] < target {
>             left = mid + 1
>         } else {
>             right = mid - 1
>         }
>     }
>     return result
> }
> ```

> [!info]- Solution 2: Lower Bound
> ```swift
> func findFirst<T: Comparable>(_ arr: [T], _ target: T) -> Int? {
>     var left = 0
>     var right = arr.count
>
>     while left < right {
>         let mid = left + (right - left) / 2
>         if arr[mid] < target {
>             left = mid + 1
>         } else {
>             right = mid
>         }
>     }
>     return left < arr.count && arr[left] == target ? left : nil
> }
> ```

### 4. Find Last Occurrence
Return the index of the last occurrence of target in a sorted array with duplicates.

```swift
func findLast<T: Comparable>(_ arr: [T], _ target: T) -> Int?
```

| Input | Output |
|:------|:-------|
| `[1, 2, 3, 3, 3, 4], 3` | `4` |
| `[1, 2, 3, 3, 3, 4], 5` | `nil` |
| `[1, 2, 3, 4], 4` | `3` |

> [!info]- Solution 1: Search Right
> ```swift
> func findLast<T: Comparable>(_ arr: [T], _ target: T) -> Int? {
>     var left = 0
>     var right = arr.count - 1
>     var result: Int?
>
>     while left <= right {
>         let mid = left + (right - left) / 2
>         if arr[mid] == target {
>             result = mid
>             left = mid + 1
>         } else if arr[mid] < target {
>             left = mid + 1
>         } else {
>             right = mid - 1
>         }
>     }
>     return result
> }
> ```

> [!info]- Solution 2: Upper Bound - 1
> ```swift
> func findLast<T: Comparable>(_ arr: [T], _ target: T) -> Int? {
>     var left = 0
>     var right = arr.count
>
>     while left < right {
>         let mid = left + (right - left) / 2
>         if arr[mid] <= target {
>             left = mid + 1
>         } else {
>             right = mid
>         }
>     }
>     return left > 0 && arr[left - 1] == target ? left - 1 : nil
> }
> ```

### 5. Find Floor
Return the index of the largest element less than or equal to target.

```swift
func findFloor<T: Comparable>(_ arr: [T], _ target: T) -> Int?
```

| Input | Output |
|:------|:-------|
| `[1, 2, 4, 6, 8], 5` | `2` |
| `[1, 2, 4, 6, 8], 1` | `0` |
| `[1, 2, 4, 6, 8], 0` | `nil` |

> [!info]- Solution
> ```swift
> func findFloor<T: Comparable>(_ arr: [T], _ target: T) -> Int? {
>     var left = 0
>     var right = arr.count - 1
>     var result: Int?
>
>     while left <= right {
>         let mid = left + (right - left) / 2
>         if arr[mid] == target {
>             return mid
>         } else if arr[mid] < target {
>             result = mid
>             left = mid + 1
>         } else {
>             right = mid - 1
>         }
>     }
>     return result
> }
> ```

### 6. Find Ceiling
Return the index of the smallest element greater than or equal to target.

```swift
func findCeiling<T: Comparable>(_ arr: [T], _ target: T) -> Int?
```

| Input | Output |
|:------|:-------|
| `[1, 2, 4, 6, 8], 5` | `3` |
| `[1, 2, 4, 6, 8], 8` | `4` |
| `[1, 2, 4, 6, 8], 10` | `nil` |

> [!info]- Solution 1: Binary Search
> ```swift
> func findCeiling<T: Comparable>(_ arr: [T], _ target: T) -> Int? {
>     var left = 0
>     var right = arr.count - 1
>
>     while left <= right {
>         let mid = left + (right - left) / 2
>         if arr[mid] == target {
>             return mid
>         } else if arr[mid] < target {
>             left = mid + 1
>         } else {
>             right = mid - 1
>         }
>     }
>     return left < arr.count ? left : nil
> }
> ```

> [!info]- Solution 2: Built-in
> ```swift
> arr.firstIndex(where: { $0 >= target })
> ```

### 7. Search in Rotated Array
Search for target in a rotated sorted array. Return `true` if found.

```swift
func searchRotated<T: Comparable>(_ nums: [T], _ target: T) -> Bool
```

| Input | Output |
|:------|:-------|
| `[4, 5, 6, 7, 0, 1, 2], 0` | `true` |
| `[4, 5, 6, 7, 0, 1, 2], 3` | `false` |
| `[1], 1` | `true` |

> [!info]- Solution 1: Single Binary Search
> ```swift
> func searchRotated<T: Comparable>(_ nums: [T], _ target: T) -> Bool {
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
> func searchRotated<T: Comparable>(_ nums: [T], _ target: T) -> Bool {
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

### 8. Find Minimum in Rotated Array
Find the minimum element in a rotated sorted array.

```swift
func findMinRotated<T: Comparable>(_ nums: [T]) -> T
```

| Input | Output |
|:------|:-------|
| `[3, 4, 5, 1, 2]` | `1` |
| `[4, 5, 6, 7, 0, 1, 2]` | `0` |
| `[1]` | `1` |

> [!info]- Solution 1: Binary Search
> ```swift
> func findMinRotated<T: Comparable>(_ nums: [T]) -> T {
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

> [!info]- Solution 2: Built-in
> ```swift
> nums.min()!
> ```
