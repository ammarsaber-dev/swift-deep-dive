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

### 1. Find Element
Return the index of the target, or `nil` if not found.

```swift
func linearSearch<T: Equatable>(_ arr: [T], _ target: T) -> Int?
```

| Input | Output |
|:------|:-------|
| `[1, 2, 3, 4, 5], 3` | `2` |
| `[1, 2, 3, 4, 5], 6` | `nil` |
| `["a", "b", "c"], "b"` | `1` |

> [!info]- Solution 1: Loop
> ```swift
> func linearSearch<T: Equatable>(_ arr: [T], _ target: T) -> Int? {
>     for i in 0..<arr.count {
>         if arr[i] == target {
>             return i
>         }
>     }
>     return nil
> }
> ```

> [!info]- Solution 2: Enumerated
> ```swift
> func linearSearch<T: Equatable>(_ arr: [T], _ target: T) -> Int? {
>     guard !arr.isEmpty else { return nil }
>     for (index, element) in arr.enumerated() where element == target {
>         return index
>     }
>     return nil
> }
> ```

> [!info]- Solution 3: Built-in
> ```swift
> arr.firstIndex(where: { $0 == target })
> ```

### 2. Find All Occurrences
Return an array of all indices where the target appears.

```swift
func findAll<T: Equatable>(_ arr: [T], _ target: T) -> [Int]
```

| Input | Output |
|:------|:-------|
| `[1, 2, 3, 2, 4], 2` | `[1, 3]` |
| `[1, 2, 3], 5` | `[]` |
| `["a", "a", "a"], "a"` | `[0, 1, 2]` |

> [!info]- Solution 1: Loop
> ```swift
> func findAll<T: Equatable>(_ arr: [T], _ target: T) -> [Int] {
>     var indices: [Int] = []
>     for i in 0..<arr.count {
>         if arr[i] == target {
>             indices.append(i)
>         }
>     }
>     return indices
> }
> ```

> [!info]- Solution 2: Enumerated
> ```swift
> func findAll<T: Equatable>(_ arr: [T], _ target: T) -> [Int] {
>     var indices = [Int]()
>     for (index, element) in arr.enumerated() where element == target {
>         indices.append(index)
>     }
>     return indices
> }
> ```

> [!info]- Solution 3: Filter/Map
> ```swift
> arr.indices.filter { arr[$0] == target }
> ```

### 3. Count Occurrences
Return how many times the target appears in the array.

```swift
func countOccurrences<T: Equatable>(_ arr: [T], _ target: T) -> Int
```

| Input | Output |
|:------|:-------|
| `[1, 2, 3, 2, 4], 2` | `2` |
| `[1, 2, 3], 5` | `0` |
| `["a", "a", "a"], "a"` | `3` |

> [!info]- Solution 1: Loop
> ```swift
> func countOccurrences<T: Equatable>(_ arr: [T], _ target: T) -> Int {
>     var count = 0
>     for i in 0..<arr.count {
>         if arr[i] == target {
>             count += 1
>         }
>     }
>     return count
> }
> ```

> [!info]- Solution 2: Enumerated
> ```swift
> func countOccurrences<T: Equatable>(_ arr: [T], _ target: T) -> Int {
>     var counter = 0
>     for ele in arr where ele == target {
>         counter += 1
>     }
>     return counter
> }
> ```

> [!info]- Solution 3: Filter Count
> ```swift
> arr.filter { $0 == target }.count
> ```

### 4. Check If Exists
Return `true` if the target exists in the array.

```swift
func exists<T: Equatable>(_ arr: [T], _ target: T) -> Bool
```

| Input | Output |
|:------|:-------|
| `[1, 2, 3], 2` | `true` |
| `[1, 2, 3], 5` | `false` |
| `["a", "b"], "c"` | `false` |

> [!info]- Solution 1: Loop
> ```swift
> func exists<T: Equatable>(_ arr: [T], _ target: T) -> Bool {
>     for i in 0..<arr.count {
>         if arr[i] == target {
>             return true
>         }
>     }
>     return false
> }
> ```

> [!info]- Solution 2: Contains
> ```swift
> arr.contains(target)
> ```

> [!info]- Solution 3: First Index
> ```swift
> arr.firstIndex(where: { $0 == target }) != nil
> ```

### 5. Find Last Occurrence
Return the index of the last occurrence of the target.

```swift
func findLast<T: Equatable>(_ arr: [T], _ target: T) -> Int?
```

| Input | Output |
|:------|:-------|
| `[1, 2, 3, 2, 4], 2` | `3` |
| `[1, 2, 3], 5` | `nil` |
| `["a"], "a"` | `0` |

> [!info]- Solution 1: Loop
> ```swift
> func findLast<T: Equatable>(_ arr: [T], _ target: T) -> Int? {
>     var lastIndex: Int?
>     for i in 0..<arr.count {
>         if arr[i] == target {
>             lastIndex = i
>         }
>     }
>     return lastIndex
> }
> ```

> [!info]- Solution 2: Reversed
> ```swift
> func findLast<T: Equatable>(_ arr: [T], _ target: T) -> Int? {
>     for (index, element) in arr.enumerated().reversed() where element == target {
>         return index
>     }
>     return nil
> }
> ```

> [!info]- Solution 3: Last Index
> ```swift
> arr.lastIndex(where: { $0 == target })
> ```

### 6. Find Minimum
Return the index of the minimum element.

```swift
func findMin<T: Comparable>(_ arr: [T]) -> Int?
```

| Input | Output |
|:------|:-------|
| `[3, 1, 4, 1, 5], 3` | `1` |
| `[5]` | `0` |
| `[1, 2, 3]` | `0` |

> [!info]- Solution 1: Loop
> ```swift
> func findMin<T: Comparable>(_ arr: [T]) -> Int? {
>     guard !arr.isEmpty else { return nil }
>     var minIndex = 0
>     for i in 1..<arr.count {
>         if arr[i] < arr[minIndex] {
>             minIndex = i
>         }
>     }
>     return minIndex
> }
> ```

> [!info]- Solution 2: Min Element
> ```swift
> func findMin<T: Comparable>(_ arr: [T]) -> Int? {
>     guard let minVal = arr.min() else { return nil }
>     return arr.firstIndex(of: minVal)
> }
> ```

> [!info]- Solution 3: Min Index
> ```swift
> arr.indices.min(by: { arr[$0] < arr[$1] })
> ```
