# Linear Search

#algorithm #searching #array #brute-force

> [!contents]+ Contents
> - [[#How It Works]]
> - [[#Performance Complexity]]
> - [[#Implementation]]
> - [[#Challenges]]

Go through each element, one by one, until you find it.

![](https://turboyourcode.s3.amazonaws.com/media/Linear_Search.gif)

## How It Works

1. Start at the first element.
2. Is it the target? **Yes** → return index. **No** → next element.
3. Repeat until found or end of array.

## Performance Complexity

| Case | Time | Space |
|:-----|:-----|:------|
| Best | O(1) | O(1) |
| Worst | O(n) | O(1) |
| Average | O(n) | O(1) |

## Implementation

**Iterative** — Time: `O(n)` | Space: `O(1)`
```swift
func linearSearch(_ arr: [Int], _ key: Int) -> Int? {
    for i in 0..<arr.count {
        if arr[i] == key {
            return i
        }
    }
    return nil
}
```

**Recursive** — Time: `O(n)` | Space: `O(n)` stack
```swift
func linearSearchRecursive(_ arr: [Int], _ key: Int, _ index: Int = 0) -> Int? {
    guard index < arr.count else { return nil }
    if arr[index] == key { return index }
    return linearSearchRecursive(arr, key, index + 1)
}
```

**Built-in** — Time: `O(n)`
```swift
numbers.firstIndex(where: { $0 == 5 })
```

## Challenges

### 1. Find First Index
`Easy` | [LeetCode 28](https://leetcode.com/problems/find-the-index-of-the-first-occurrence-in-a-string/)

Given two strings `needle` and `haystack`, return the index of the first occurrence of `needle` in `haystack`, or `-1` if not found.

```swift
func strStr(_ haystack: String, _ needle: String) -> Int
```

| Example | Output |
|:--------|:-------|
| `"sadbutsad", "sad"` | `0` |
| `"leetcode", "leeto"` | `-1` |
| `"hello", "ll"` | `2` |

> [!info]- Solution 1: Brute Force
> ```swift
> func strStr(_ haystack: String, _ needle: String) -> Int {
>     let h = Array(haystack)
>     let n = Array(needle)
>     if n.isEmpty { return 0 }
>     if h.count < n.count { return -1 }
>
>     for i in 0...h.count - n.count {
>         var j = 0
>         while j < n.count && h[i + j] == n[j] {
>             j += 1
>         }
>         if j == n.count { return i }
>     }
>     return -1
> }
> ```

> [!info]- Solution 2: Built-in
> ```swift
> func strStr(_ haystack: String, _ needle: String) -> Int {
>     if let range = haystack.range(of: needle) {
>         return haystack.distance(from: haystack.startIndex, to: range.lowerBound)
>     }
>     return -1
> }
> ```

### 2. Contains Duplicate
`Easy` | [LeetCode 217](https://leetcode.com/problems/contains-duplicate/)

Given an integer array `nums`, return `true` if any value appears at least twice, `false` if every element is distinct.

```swift
func containsDuplicate(_ nums: [Int]) -> Bool
```

| Example | Output |
|:--------|:-------|
| `[1,2,3,1]` | `true` |
| `[1,2,3,4]` | `false` |
| `[1,1,1,3,3,4,3,2,4,2]` | `true` |

> [!info]- Solution 1: Brute Force
> ```swift
> func containsDuplicate(_ nums: [Int]) -> Bool {
>     for i in 0..<nums.count {
>         for j in (i + 1)..<nums.count {
>             if nums[i] == nums[j] { return true }
>         }
>     }
>     return false
> }
> ```

> [!info]- Solution 2: Set
> ```swift
> func containsDuplicate(_ nums: [Int]) -> Bool {
>     var seen = Set<Int>()
>     for num in nums {
>         if seen.contains(num) { return true }
>         seen.insert(num)
>     }
>     return false
> }
> ```

> [!info]- Solution 3: Sorting
> ```swift
> func containsDuplicate(_ nums: [Int]) -> Bool {
>     let sorted = nums.sorted()
>     for i in 0..<(sorted.count - 1) {
>         if sorted[i] == sorted[i + 1] { return true }
>     }
>     return false
> }
> ```

### 3. Valid Anagram
`Easy` | [LeetCode 242](https://leetcode.com/problems/valid-anagram/)

Given two strings `s` and `t`, return `true` if `t` is an anagram of `s`.

```swift
func isAnagram(_ s: String, _ t: String) -> Bool
```

| Example | Output |
|:--------|:-------|
| `"anagram", "nagaram"` | `true` |
| `"rat", "car"` | `false` |
| `"a", "a"` | `true` |

> [!info]- Solution 1: HashMap
> ```swift
> func isAnagram(_ s: String, _ t: String) -> Bool {
>     guard s.count == t.count else { return false }
>     var count = [Character: Int]()
>     for char in s {
>         count[char, default: 0] += 1
>     }
>     for char in t {
>         count[char, default: 0] -= 1
>         if count[char]! < 0 { return false }
>     }
>     return true
> }
> ```

> [!info]- Solution 2: Sorted Strings
> ```swift
> func isAnagram(_ s: String, _ t: String) -> Bool {
>     guard s.count == t.count else { return false }
>     return s.sorted() == t.sorted()
> }
> ```

> [!info]- Solution 3: Character Count
> ```swift
> func isAnagram(_ s: String, _ t: String) -> Bool {
>     guard s.count == t.count else { return false }
>     var count = [Int](repeating: 0, count: 26)
>     let aValue = Int(Character("a").asciiValue!)
>
>     for char in s {
>         count[Int(char.asciiValue!) - aValue] += 1
>     }
>     for char in t {
>         count[Int(char.asciiValue!) - aValue] -= 1
>         if count[Int(char.asciiValue!) - aValue] < 0 { return false }
>     }
>     return true
> }
> ```

### 4. Two Sum
`Easy` | [LeetCode 1](https://leetcode.com/problems/two-sum/)

Given array of integers and target, return indices of two numbers that add up to target.

```swift
func twoSum(_ nums: [Int], _ target: Int) -> [Int]
```

| Example | Output |
|:--------|:-------|
| `[2,7,11,15], 9` | `[0,1]` |
| `[3,2,4], 6` | `[1,2]` |
| `[3,3], 6` | `[0,1]` |

> [!info]- Solution 1: Brute Force
> ```swift
> func twoSum(_ nums: [Int], _ target: Int) -> [Int] {
>     for i in 0..<nums.count {
>         for j in (i + 1)..<nums.count {
>             if nums[i] + nums[j] == target {
>                 return [i, j]
>             }
>         }
>     }
>     return []
> }
> ```

> [!info]- Solution 2: HashMap
> ```swift
> func twoSum(_ nums: [Int], _ target: Int) -> [Int] {
>     var map = [Int: Int]()
>     for (i, num) in nums.enumerated() {
>         if let j = map[target - num] {
>             return [j, i]
>         }
>         map[num] = i
>     }
>     return []
> }
> ```

### 5. Move Zeroes
`Easy` | [LeetCode 283](https://leetcode.com/problems/move-zeroes/)

Move all `0`'s to the end while maintaining relative order of non-zero elements. Modify in-place.

```swift
func moveZeroes(_ nums: inout [Int])
```

| Example | Output |
|:--------|:-------|
| `[0,1,0,3,12]` | `[1,3,12,0,0]` |
| `[0]` | `[0]` |
| `[1,2,3]` | `[1,2,3]` |

> [!info]- Solution 1: Two Pointers
> ```swift
> func moveZeroes(_ nums: inout [Int]) {
>     var insertPos = 0
>     for num in nums where num != 0 {
>         nums[insertPos] = num
>         insertPos += 1
>     }
>     while insertPos < nums.count {
>         nums[insertPos] = 0
>         insertPos += 1
>     }
> }
> ```

> [!info]- Solution 2: Swap
> ```swift
> func moveZeroes(_ nums: inout [Int]) {
>     var i = 0
>     for j in 0..<nums.count {
>         if nums[j] != 0 {
>             nums.swapAt(i, j)
>             i += 1
>         }
>     }
> }
> ```

### 6. Majority Element
`Easy` | [LeetCode 169](https://leetcode.com/problems/majority-element/)

Given array of size `n`, return the majority element (appears > ⌊n/2⌋ times). Majority element always exists.

```swift
func majorityElement(_ nums: [Int]) -> Int
```

| Example | Output |
|:--------|:-------|
| `[3,2,3]` | `3` |
| `[2,2,1,1,1,2,2]` | `2` |
| `[1]` | `1` |

> [!info]- Solution 1: Boyer-Moore Voting
> ```swift
> func majorityElement(_ nums: [Int]) -> Int {
>     var candidate = 0
>     var count = 0
>     for num in nums {
>         if count == 0 {
>             candidate = num
>         }
>         count += (num == candidate) ? 1 : -1
>     }
>     return candidate
> }
> ```

> [!info]- Solution 2: HashMap
> ```swift
> func majorityElement(_ nums: [Int]) -> Int {
>     var count = [Int: Int]()
>     for num in nums {
>         count[num, default: 0] += 1
>         if count[num]! > nums.count / 2 { return num }
>     }
>     return nums[0]
> }
> ```

> [!info]- Solution 3: Sorting
> ```swift
> func majorityElement(_ nums: [Int]) -> Int {
>     return nums.sorted()[nums.count / 2]
> }
> ```
