# Binary Search

#algorithm #search #array #divide-and-conquer #sorted

> Cut the search space in half with every single comparison.

![](https://d18l82el6cdm1i.cloudfront.net/uploads/bePceUMnSG-binary_search_gif.gif)

---

## Contents

- [[#The Core Idea]]
- [[#How It Works]]
- [[#Worked Example]]
- [[#Performance Complexity]]
- [[#The Integer Overflow Trap]]
- [[#When to Actually Use It]]
- [[#Edge Cases to Know]]
- [[#Implementation]]
- [[#The Built-in Reality Check]]
- [[#Practice & Resources]]

---

## The Core Idea

Binary search is the algorithm equivalent of opening a dictionary. You don't start at page 1 looking for "zebra" — you open to the middle, see you're in the M's, and flip right. Then again. Then again. Within seconds you're there.

That intuition is the whole algorithm. The only rule: **the array must be sorted first.** (not always tbh)

---

## How It Works

Binary search maintains two pointers — `left` and `right` — that define the current _search space_. Each step, it:

1. Finds the **middle element** of the current search space.
2. Compares it to the target:
    - `arr[mid] == target` → found it, return `mid`
    - `arr[mid] < target` → target is in the **right half**, move `left = mid + 1`
    - `arr[mid] > target` → target is in the **left half**, move `right = mid - 1`
3. Repeats until found or `left > right` (search space is empty → not found).

> [!warning] The array **must be sorted**. Binary search on an unsorted array produces nonsense results without panicking — it will silently return the wrong answer or `nil`.

---

## Worked Example

Finding `43` in:

```
[2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67]
  0  1  2  3   4   5   6   7   8   9  10  11  12  13  14  15  16  17  18
```

**Step 1** — `left=0`, `right=18` → `mid=9` → `arr[9]=29`

```
[2, 3, 5, 7, 11, 13, 17, 19, 23, [29], 31, 37, 41, 43, 47, 53, 59, 61, 67]
                                    ^
43 > 29 → search right half
```

**Step 2** — `left=10`, `right=18` → `mid=14` → `arr[14]=47`

```
[... 31, 37, 41, 43, [47], 53, 59, 61, 67]
                      ^
43 < 47 → search left half
```

**Step 3** — `left=10`, `right=13` → `mid=11` → `arr[11]=37`

```
[... 31, [37], 41, 43 ...]
           ^
43 > 37 → search right half
```

**Step 4** — `left=12`, `right=13` → `mid=12` → `arr[12]=41`

```
[... [41], 43 ...]
      ^
43 > 41 → search right half
```

**Step 5** — `left=13`, `right=13` → `mid=13` → `arr[13]=43`

```
[... [43] ...]
      ^
43 == 43 → ✓ found at index 13
```

19 elements. 5 steps. A linear scan would have taken up to 19.

---

## Performance Complexity

|Case|Time|Space|When|
|---|---|---|---|
|Best|O(1)|O(1)|Target is the middle element on the first check|
|Worst|O(log n)|O(1)|Target is at an edge, or not present|
|Average|O(log n)|O(1)|—|

**Why O(log n)?** Each step halves the search space. To reduce n elements down to 1:

$$n \div 2^k = 1 \implies k = \log_2 n$$

That means **1,000,000 elements takes at most 20 steps**. 1,000,000,000 elements? Only 30.

> [!tip] The recursive version has O(log n) _space_ complexity due to the call stack depth, not O(1). Use the iterative version when memory is a constraint.

---

## The Integer Overflow Trap

You might expect the midpoint to be calculated as:

```swift
let mid = (left + right) / 2  // ⚠️ dangerous
```

This looks right, but it can **overflow** in languages with fixed-width integers. If `left = 1,000,000,000` and `right = 1,500,000,000`, their sum exceeds `Int32.max` (2,147,483,647) and wraps to a negative number.

The safe version:

```swift
let mid = left + (right - left) / 2  // ✓ safe
```

This computes the _offset from `left`_ instead of the raw average. The difference is subtle but bites people in interviews and production code alike.

Swift's `Int` is 64-bit on modern platforms so overflow is less of a day-to-day concern, but the safe form is the correct habit to build.

---

## When to Actually Use It

Binary search is fast, but it has a prerequisite that matters:

**Use binary search when:**

- The collection is **sorted** (or can be sorted once and searched many times)
- The collection supports **random access** (arrays, not linked lists — pointer-walking to `mid` would destroy the complexity)
- You need **many searches** on the same data — the O(n log n) sort cost amortises quickly

**Don't use binary search when:**

- You need to search an **unsorted** array you won't be sorting (linear search is fine)
- The collection only supports **sequential access** (linked lists, streams)
- You're doing a **one-off search** on a small array — the constant factor doesn't matter

---

## Edge Cases to Know

Your implementation should handle these without special-casing:

|Scenario|Expected|What can go wrong|
|---|---|---|
|Empty array `[]`|Return `nil`|Index out of bounds if `right = -1` not handled|
|Single element, matches|Return `0`|Usually fine|
|Single element, no match|Return `nil`|Usually fine|
|Target smaller than all elements|Return `nil`|Left pointer walks past right|
|Target larger than all elements|Return `nil`|Right pointer walks past left|
|Duplicate elements|Returns _an_ index (not necessarily the first)|If you need the _first_ occurrence, you need a modified variant|

The iterative implementation below handles all of these correctly via the `while left <= right` invariant.

---

## Implementation

### Iterative

**Time: O(log n) | Space: O(1)**

```swift
func binarySearch(_ arr: [Int], _ target: Int) -> Int? {
    var left = 0
    var right = arr.count - 1

    while left <= right {
        let mid = left + (right - left) / 2  // safe midpoint

        if arr[mid] == target {
            return mid
        } else if arr[mid] < target {
            left = mid + 1
        } else {
            right = mid - 1
        }
    }

    return nil
}
```

This is the form to default to. No stack growth, handles all edge cases through the loop invariant.

---

### Recursive

**Time: O(log n) | Space: O(log n) stack**

```swift
func binarySearch(_ arr: [Int], _ target: Int, _ left: Int = 0, _ right: Int? = nil) -> Int? {
    // `right` defaults to nil so callers don't need to pass arr.count - 1
    let end = right ?? arr.count - 1
    guard left <= end else { return nil }

    let mid = left + (end - left) / 2

    if arr[mid] == target {
        return mid
    } else if arr[mid] < target {
        return binarySearch(arr, target, mid + 1, end)
    } else {
        return binarySearch(arr, target, left, mid - 1)
    }
}
```

Elegant, but each call frame lives on the stack until the base case is reached. For 1,000,000 elements that's ~20 frames — harmless in practice, but worth knowing.

---

### Generic Version

Both implementations above are `[Int]`-only. In real code, make it generic over `Comparable`:

```swift
func binarySearch<T: Comparable>(_ arr: [T], _ target: T) -> Int? {
    var left = 0
    var right = arr.count - 1

    while left <= right {
        let mid = left + (right - left) / 2

        if arr[mid] == target {
            return mid
        } else if arr[mid] < target {
            left = mid + 1
        } else {
            right = mid - 1
        }
    }

    return nil
}
```

Now it works on `[String]`, `[Double]`, or any type conforming to `Comparable`.

---

## The Built-in Reality Check

The Swift Standard Library **does not** include a native `binarySearch(_:)` on `Array`. For developers looking for a built-in or idiomatic way to perform a binary search, there are two primary options:

### The Idiomatic Way: `partitioningIndex(where:)`

**Time: O(log n) | Space: O(1)**

```swift
// If you use Apple's `swift-algorithms` package, this is the official binary search
let index = numbers.partitioningIndex(where: { $0 >= target })
```

### The "Cleanest" Custom Solution

**Time: O(log n) | Space: O(1)**

```swift
extension RandomAccessCollection {
    func binarySearch(where predicate: (Element) -> Bool) -> Index {
        var left = startIndex
        var right = endIndex

        while left < right {
            let mid = index(left, offsetBy: distance(from: left, to: right) / 2) // safe midpoint

            if predicate(self[mid]) {
                right = mid
            } else {
                left = index(after: mid)
            }
        }
        return left
    }
}

// Usage:
let index = numbers.binarySearch(where: { $0 >= target })
```

> [!info] **Understanding Generic Indexing**
> If you are used to other languages, you might expect `(left + right) / 2`. Here is why we use this "wordier" Swift version:
> 
> 1. **Indices aren't always numbers:** In Swift, an `Index` is its own type. For some collections (like `String`), you cannot add two indices together—it's like trying to add two physical addresses.
> 2. **Slices don't start at 0:** If you take a slice of an array from index 10 to 20, the `startIndex` is `10`. Simple math like `right / 2` would point you to the wrong spot or cause a crash.
> 
> **How to read the logic:**
> - `distance(from: left, to: right)`: "How many elements are currently between my two pointers?"
> - `/ 2`: "Give me half of that count."
> - `index(left, offsetBy: ...)`: "Start at the `left` pointer and move forward by that half-count."
> 
> This "Protocol-Oriented" approach ensures your code is universal—it works perfectly on Arrays, Slices, and custom collections alike!

---
## Linear vs Binary Search

| |Linear Search|Binary Search|
|---|---|---|
|Sorted required?|No|**Yes**|
|Random access required?|No|**Yes**|
|Time complexity|O(n)|O(log n)|
|Space (iterative)|O(1)|O(1)|
|First occurrence guaranteed?|**Yes**|No (basic version)|
|Works on linked lists/streams?|**Yes**|No|
|Best for|Unsorted, small, one-off, predicate-based|Sorted arrays, repeated lookups|

The choice isn't "linear is slow, binary is fast." It's "do I meet binary search's preconditions?" If yes, use binary search. If no, linear search is the right answer — not a compromise.

---

## Leetcode Problems

| Done                                          | Problem                                                                                                                                               | Difficulty | Video Solution                                             |
| :-------------------------------------------- | :---------------------------------------------------------------------------------------------------------------------------------------------------- | :--------- | :--------------------------------------------------------- |
| <input type="checkbox">                       | [35. Search Insert Position](https://leetcode.com/problems/search-insert-position/)                                                                   | **Easy**   | [Watch Video](https://www.youtube.com/watch?v=K-RYzDZkzCI) |
| <input type="checkbox">                       | [367. Valid Perfect Square](https://leetcode.com/problems/valid-perfect-square/)                                                                      | **Easy**   | [Watch Video](https://www.youtube.com/watch?v=Cg_wWPHJ2Sk) |
| <input type="checkbox">                       | [374. Guess Number Higher or Lower](https://leetcode.com/problems/guess-number-higher-or-lower/)                                                      | **Easy**   | [Watch Video](https://www.youtube.com/watch?v=xW4QsTtaCa4) |
| <input type="checkbox">                       | [441. Arranging Coins](https://leetcode.com/problems/arranging-coins/)                                                                                | **Easy**   | [Watch Video](https://www.youtube.com/watch?v=5rHz_6s2Buw) |
| <input type="checkbox">                       | [704. Binary Search](https://leetcode.com/problems/binary-search/)                                                                                    | **Easy**   | [Watch Video](https://www.youtube.com/watch?v=s4DPM8ct1pI) |
| <input type="checkbox" checked id="ba8950"> | [162. Find Peak Element](https://leetcode.com/problems/find-peak-element/)                                                                            | **Medium** | [Watch Video](https://www.youtube.com/watch?v=RrGv2OPBl8U) |
| <input type="checkbox">                       | [33. Search in Rotated Sorted Array](https://leetcode.com/problems/search-in-rotated-sorted-array/)                                                   | **Medium** | [Watch Video](https://www.youtube.com/watch?v=U8XENwh8Oy8) |
| <input type="checkbox">                       | [34. Find First and Last Position of Element in Sorted Array](https://leetcode.com/problems/find-first-and-last-position-of-element-in-sorted-array/) | **Medium** | [Watch Video](https://www.youtube.com/watch?v=4sQL7R5ySUU) |
| <input type="checkbox">                       | [74. Search a 2D Matrix](https://leetcode.com/problems/search-a-2d-matrix/)                                                                           | **Medium** | [Watch Video](https://www.youtube.com/watch?v=Ber2pi2C0j0) |
| <input type="checkbox">                       | [153. Find Minimum in Rotated Sorted Array](https://leetcode.com/problems/find-minimum-in-rotated-sorted-array/)                                      | **Medium** | [Watch Video](https://www.youtube.com/watch?v=nIVW4P8b1VA) |
| <input type="checkbox">                       | [658. Find K Closest Elements](https://leetcode.com/problems/find-k-closest-elements/)                                                                | **Medium** | [Watch Video](https://www.youtube.com/watch?v=o-YDQzHoaKM) |
| <input type="checkbox">                       | [875. Koko Eating Bananas](https://leetcode.com/problems/koko-eating-bananas/)                                                                        | **Medium** | [Watch Video](https://www.youtube.com/watch?v=U2SozAs9RzA) |
| <input type="checkbox">                       | [981. Time Based Key-Value Store](https://leetcode.com/problems/time-based-key-value-store/)                                                          | **Medium** | [Watch Video](https://www.youtube.com/watch?v=fu2cD_6E8Hw) |
| <input type="checkbox">                       | [1898. Maximum Number of Removable Characters](https://leetcode.com/problems/maximum-number-of-removable-characters/)                                 | **Medium** | [Watch Video](https://www.youtube.com/watch?v=NMP3nRPyX5g) |
| <input type="checkbox">                       | [4. Median of Two Sorted Arrays](https://leetcode.com/problems/median-of-two-sorted-arrays/)                                                          | **Hard**   | [Watch Video](https://www.youtube.com/watch?v=q6IEA26hvXc) |
| <input type="checkbox">                       | [410. Split Array Largest Sum](https://leetcode.com/problems/split-array-largest-sum/)                                                                | **Hard**   | [Watch Video](https://www.youtube.com/watch?v=YUF3_eBdzsk) |