# Linear Search

#algorithm #searching #array #brute-force

> No preconditions. No setup. Just walk and look.

![](https://turboyourcode.s3.amazonaws.com/media/Linear_Search.gif)

---

## Contents

- [[#The Core Idea]]
- [[#How It Works]]
- [[#Performance Complexity]]
- [[#When to Actually Use It]]
- [[#Edge Cases to Know]]
- [[#Implementation]]
- [[#The Swift Built-in]]
- [[#Linear vs Binary Search]]

---

## The Core Idea

Linear search is the simplest searching algorithm — and often the most appropriate one. You scan every element in order until you find your target or exhaust the array. No sorting required. No random access required. No setup cost.

It gets dismissed as the "slow" option, but that framing misses the point. Linear search shines precisely in situations where [[Binary Search]] can't even start.

---

## How It Works

1. Start at index `0`.
2. Compare the current element to the target.
    - Match → return the current index.
    - No match → advance to `index + 1`.
3. Repeat until found or the array ends → return `nil`.

No tricks. No invariants to maintain. The simplicity is a feature.

---

## Performance Complexity

|Case|Time|Space|When|
|---|---|---|---|
|Best|O(1)|O(1)|Target is the first element|
|Worst|O(n)|O(1)|Target is the last element, or not present|
|Average|O(n/2) = O(n)|O(1)|Target is somewhere in the middle|

The average case is technically O(n/2) — you'll check roughly half the elements on average before finding your target — but constants disappear in Big O notation, so it's written O(n).

> [!tip] If you're searching the **same unsorted array repeatedly**, consider sorting it once (O(n log n)) and switching to binary search (O(log n) per query). The upfront cost pays off quickly.

> [!note] The recursive version has O(n) _space_ complexity due to call stack depth — one frame per element in the worst case. For large arrays, this risks a stack overflow. Always prefer the iterative version in practice.

---

## When to Actually Use It

Linear search isn't a fallback — it's the right tool in specific situations:

**Use linear search when:**

- The array is **unsorted** and sorting it isn't worth it (one-off search, small data)
- The collection doesn't support **random access** — linked lists, streams, generators
- You're searching for a **non-comparable** property (e.g. first element where `user.isActive == true`)
- The array is **small** (under ~20 elements — the binary search overhead isn't worth it)
- You need the **first match** of a predicate, not an exact value

**Don't use linear search when:**

- The array is already **sorted** — use [Binary Search](03.%20Algorithms/Searching/02.%20Binary%20Search/README.md)
- You're running **many searches** on the same large dataset — sort once, search fast

---

## Edge Cases to Know

|Scenario|Expected|Notes|
|---|---|---|
|Empty array `[]`|Return `nil`|Loop never executes — handled automatically|
|Target not present|Return `nil`|Loop exhausts without returning|
|Duplicate elements|Returns the **first** index|Unlike binary search, this behaviour is guaranteed|
|Single element, matches|Return `0`|Fine|
|Single element, no match|Return `nil`|Fine|

The duplicate behaviour is worth noting: linear search always returns the _first_ occurrence, making it predictable in a way that basic binary search isn't.

---

## Implementation

### Iterative

**Time: O(n) | Space: O(1)**

```swift
func linearSearch(_ arr: [Int], _ target: Int) -> Int? {
    for i in 0..<arr.count {
        if arr[i] == target {
            return i
        }
    }
    return nil
}
```

This is the form to default to. Clean, O(1) space, no risk of stack overflow.

---

### Iterative with `enumerated()` (more Swifty)

```swift
func linearSearch(_ arr: [Int], _ target: Int) -> Int? {
    for (index, value) in arr.enumerated() {
        if value == target {
            return index
        }
    }
    return nil
}
```

Same complexity, but reads closer to intent — you're iterating elements, not managing an index manually.

---

### Recursive

**Time: O(n) | Space: O(n) stack**

```swift
func linearSearch(_ arr: [Int], _ target: Int, _ index: Int = 0) -> Int? {
    guard index < arr.count else { return nil }
    if arr[index] == target { return index }
    return linearSearch(arr, target, index + 1)
}
```

Elegant for understanding recursion, but each call adds a frame to the stack. For an array of 10,000 elements, that's 10,000 frames in the worst case — not suitable for production use on large inputs.

---

### Generic Version

```swift
func linearSearch<T: Equatable>(_ arr: [T], _ target: T) -> Int? {
    for (index, value) in arr.enumerated() {
        if value == target {
            return index
        }
    }
    return nil
}
```

Note the constraint: only `Equatable` is needed here (not `Comparable`). This is _weaker_ than binary search's `Comparable`requirement — linear search works on any type that can be checked for equality, even types with no defined ordering.

---

## The Swift Built-in

```swift
// firstIndex(of:) — searches for an exact value. O(n).
numbers.firstIndex(of: 5)

// firstIndex(where:) — searches by predicate. O(n).
numbers.firstIndex(where: { $0 > 10 })
users.firstIndex(where: { $0.isAdmin })
```

Both perform a linear scan. `firstIndex(of:)` requires `Equatable`; `firstIndex(where:)` accepts any predicate, making it the more flexible option for real-world searches.

These are the idiomatic Swift way to do linear search — reach for them over a manual loop unless you have a specific reason not to.

---

## Leetcode Problems

|                         | Problem                                                                                                                 | Difficulty | Video Solution                                             |
| ----------------------- | ----------------------------------------------------------------------------------------------------------------------- | ---------- | ---------------------------------------------------------- |
| <input type="checkbox"> | [1295. Find Numbers with Even Number of Digits](https://leetcode.com/problems/find-numbers-with-even-number-of-digits/) | **Easy**   | [Watch Video](https://www.youtube.com/watch?v=HRp8mNJvLZ0) |
| <input type="checkbox"> | [2089. Find Target Indices After Sorting Array](https://leetcode.com/problems/find-target-indices-after-sorting-array/) | **Easy**   | [Watch Video](https://www.youtube.com/watch?v=_tYhstE0u_A) |
| <input type="checkbox"> | [1539. Kth Missing Positive Number](https://leetcode.com/problems/kth-missing-positive-number/)                         | **Easy**   | [Watch Video](https://www.youtube.com/watch?v=p0P1JNHAB-c) |
| <input type="checkbox"> | [1672. Richest Customer Wealth](https://leetcode.com/problems/richest-customer-wealth/)                                 | **Easy**   | [Watch Video](https://www.youtube.com/watch?v=1PdfTbSTDXc) |
| <input type="checkbox"> | [275. H-Index II](https://leetcode.com/problems/h-index-ii/)                                                            | **Medium** | [Watch Video](https://www.youtube.com/watch?v=m5igTaeo9Ik) |
| <input type="checkbox"> | [162. Find Peak Element](https://leetcode.com/problems/find-peak-element/)                                              | **Medium** | [Watch Video](https://www.youtube.com/watch?v=RrGv2OPBl8U) |
