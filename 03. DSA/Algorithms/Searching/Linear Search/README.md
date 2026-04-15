# Linear Search

#algorithm #searching #array #brute-force

> [!warning]- ⚠️ For optimal experience, open this vault in [Obsidian](https://obsidian.md/)

> [!contents]+ Contents
> - [[#How It Works]]
> - [[#Performance Complexity]]
> - [[#Implementation]]
> - [[#Challenges]]
> - [[#Solutions]]

Go through each element, one by one, until you find it.

![](https://turboyourcode.s3.amazonaws.com/media/Linear_Search.gif)

---
## How It Works
1. Start at the first element.
2. Is it the target? 
   * **Yes** → done, return the index.
   * **No** → move to the next element.
3. Repeat until you find it or reach the end.
4. Not found → return `nil`.

---
## Performance Complexity

| Case        | Time             | Space            | Notes                                                                                                             |
| :---------- | :--------------- | :--------------- | :---------------------------------------------------------------------------------------------------------------- |
| **Best**    | $\mathcal{O}(1)$ | $\mathcal{O}(1)$ | Target is the first element.                                                                                      |
| **Worst**   | $\mathcal{O}(n)$ | $\mathcal{O}(1)$ | Target is at the end or not in the array.                                                                         |
| **Average** | $\mathcal{O}(n)$ | $\mathcal{O}(1)$ | Found in the middle ($n/2$ steps).<br>We drop constants in Big O, so $\mathcal{O}(n/2)$ becomes $\mathcal{O}(n)$. |

*Space is always $\mathcal{O}(1)$ because it only uses a single index counter variable in memory.*

---
## Implementation

```swift
func linearSearch(in arr: [Int], for key: Int) -> Int? {
    for (idx, ele) in arr.enumerated() {
        if ele == key {
            return idx
        }
    }
    return nil
}

// ==================================================================

func swiftyLinearSearch(in arr: [Int], for key: Int) -> Int? {
    for (idx, ele) in arr.enumerated() where ele == key {
        return idx
    }
    return nil
}

let numbers = [1, 91, 72, 10, 5, 34]

if let index = linearSearch(in: numbers, for: 5) {
    print("Found the element at index \(index)")
} else {
    print("Element not found")
}

// output: Found the element at index 4
```

---

## Challenges

| Challenge | Description |
|-----------|-------------|
| [allOccurrences](./Challenges/allOccurrences.swift) | Find all indices where the key exists |
| [countOccurrences](./Challenges/countOccurrences.swift) | Count how many times the key appears |
| [findMin](./Challenges/findMin.swift) | Find the index of the smallest element |
| [hasDuplicates](./Challenges/hasDuplicates.swift) | Check if array contains duplicates |
| [firstAndLastOccurrence](./Challenges/firstAndLastOccurrence.swift) | Find first & last occurrence in sorted array |
| [searchMatrix](./Challenges/searchMatrix.swift) | Search in a 2D matrix |

---

## Solutions

> [!info]- AllOccurrences
> ```swift
> func findAllOccurrences(in arr: [Int], key: Int) -> [Int] {
>     var indices: [Int] = []
>     for (idx, ele) in arr.enumerated() {
>         if ele == key {
>             indices.append(idx)
>         }
>     }
>     return indices
> }
> ```

> [!info]- CountOccurrences
> ```swift
> func countOccurrences(in arr: [Int], key: Int) -> Int {
>     var count = 0
>     for ele in arr {
>         if ele == key {
>             count += 1
>         }
>     }
>     return count
> }
> ```

> [!info]- FindMin
> ```swift
> func findMinIndex(in arr: [Int]) -> Int? {
>     guard !arr.isEmpty else { return nil }
>     var minIdx = 0
>     for idx in 1..<arr.count {
>         if arr[idx] < arr[minIdx] {
>             minIdx = idx
>         }
>     }
>     return minIdx
> }
> ```

> [!info]- HasDuplicates
> ```swift
> func hasDuplicates(in arr: [Int]) -> Bool {
>     for i in 0..<arr.count {
>         for j in (i + 1)..<arr.count {
>             if arr[i] == arr[j] {
>                 return true
>             }
>         }
>     }
>     return false
> }
> ```

> [!info]- FirstAndLastOccurrence
> ```swift
> func findFirstAndLast(in arr: [Int], key: Int) -> (first: Int, last: Int)? {
>     guard !arr.isEmpty else { return nil }
>     var first = -1
>     var last = -1
>     for (idx, ele) in arr.enumerated() {
>         if ele == key {
>             if first == -1 { first = idx }
>             last = idx
>         }
>     }
>     return first == -1 ? nil : (first, last)
> }
> ```

> [!info]- SearchMatrix
> ```swift
> func searchMatrix(_ matrix: [[Int]], key: Int) -> Bool {
>     for row in matrix {
>         for ele in row {
>             if ele == key { return true }
>         }
>     }
>     return false
> }
> ```


