# Frequency Array

#algorithm #technique #array #counting #strings

> The index is the value. The value is the count.

![](https://miro.medium.com/v2/resize:fit:2000/1*Ey1LpcctMY6Qbue8gPSUFg.gif)

---

## Contents

- [[#The Core Idea]]
- [[#How It Works]]
- [[#Performance Complexity]]
- [[#Size Matters]]
- [[#Works on Characters Too]]
- [[#Edge Cases to Know]]
- [[#When to Actually Use It]]
- [[#Implementation]]
- [[#Practice Problems]]

---

## The Core Idea

You have an array of numbers and you're receiving multiple queries — each one asking: _"how many times does this number appear?"_ The obvious approach is to loop through the array for every query. That works. But it's **O(n)** per query, and with Q queries, you're at **O(n × Q)**. With large inputs, that won't pass.

The observation that changes everything: **the array isn't changing between queries.** So why recalculate from scratch every time?

The frequency array is the answer. Instead of treating the array as a sequence to search, you treat it as a **source of counts** — you walk it once, tally everything up, and from that point forward every query is a single lookup.

The key mental flip: **use the element's value as its own index.** If the number `5` appears three times, store `3` at index `5`. The array's indices _become_ a map from value to count.

> [!info] This technique relies on a underlying [[03. Data Structures/Array/README.md|Array]] for O(1) random access. The array's indices serve as your keys — the faster you can read and write from it, the better.

---

## How It Works

1. Find the **maximum value** that can appear — this determines the frequency array's size.
2. Initialize a frequency array of zeros with size `maxValue + 1`.
3. Walk the original array once. For each element `x`, increment `freq[x]`.
4. Answer any query `"how many times does x appear?"` in **O(1)** — just return `freq[x]`.

```
original:  [3, 4, 1, 2, 1, 5, 6]

After one pass:
freq[1] = 2   ← 1 appeared twice
freq[2] = 1
freq[3] = 1
freq[4] = 1
freq[5] = 1
freq[6] = 1
```

One O(n) pass to build. Every question after that answered instantly.

---

## Performance Complexity

|Case|Time|Space|Notes|
|---|---|---|---|
|Building the frequency array|O(n)|O(maxValue)|Paid once|
|Single query|O(1)|—|Just an index lookup|
|Q queries total|O(n + Q)|O(maxValue)|vs. O(n × Q) brute force|

> [!tip] The preprocessing cost is O(n), paid once upfront. Every query after that is free. This is the same tradeoff pattern you'll see again with prefix sums — spend time preparing, save time answering.

> [!warning] The space cost is tied to `maxValue`, not `n`. If values can reach 10⁶, the frequency array needs 10⁶ slots — even if your input only has 5 elements. Always check the constraints before choosing this approach.

---

## Size Matters

The frequency array must have size **at least `maxValue + 1`**. The `+ 1` exists because arrays are zero-indexed — to safely access index `maxValue`, you need `maxValue + 1` slots total.

Always size it by the **maximum possible input value** from the constraints, not the current max in the array. A future query might ask about a value you haven't seen yet, and you need the index to exist.

---

## Works on Characters Too

The same idea applies to strings. Instead of sizing by a numeric max, size by **26** — the number of lowercase English letters. Map each character to an index by subtracting the ASCII value of `'a'`:

- `'a'` → index `0`
- `'b'` → index `1`
- `'z'` → index `25`

```swift
var freq = [Int](repeating: 0, count: 26)
let a = Int(Character("a").asciiValue!)

for ch in str {
    freq[Int(ch.asciiValue!) - a] += 1
}
```

Once you have character frequencies, you can reconstruct the **sorted version of the string** without ever calling `.sort()`— walk the frequency array from index `0` to `25`, and for each index print the character that many times. Because you're walking alphabetically, the result is already sorted.

```swift
var sorted = ""
for i in 0..<26 {
    for _ in 0..<freq[i] {
        sorted.append(Character(UnicodeScalar(a + i)!))
    }
}
```

---

## Edge Cases to Know

|Scenario|Expected|Notes|
|---|---|---|
|Element appears zero times|`freq[x] == 0`|Valid — just means it never appeared|
|Query for a value larger than `maxValue`|Index out of bounds|Size your array by constraint max, not input max|
|All elements are the same|One index holds `n`, all others hold `0`|Fine — works naturally|
|Negative values|Can't use as index directly|Shift values or use a dictionary instead|
|Very large values (e.g. up to 10⁹)|Array size is infeasible|Use a dictionary / hash map instead|

---

## When to Actually Use It

**Use a frequency array when:**

- You need to answer multiple _"how many times does X appear?"_ queries on a fixed array
- Values are **bounded, non-negative integers** — you know the max possible value upfront
- You want to sort a string by character frequency without a comparison sort
- You're building toward a prefix sum on counts — frequency arrays compose naturally with prefix sums

**Don't use it when:**

- Values are **unbounded or very large** — a dictionary is the right tool there
- The array **changes between queries** — the frequency array goes stale and needs rebuilding each time
- Values are **negative** — negative indices don't exist; shift your values or use a different structure

---

## Implementation

### Numeric — Basic Frequency Array

```swift
// O(n) build | O(1) query | O(maxVal) space
func buildFrequency(_ arr: [Int], maxVal: Int) -> [Int] {
    var freq = [Int](repeating: 0, count: maxVal + 1)
    for x in arr { freq[x] += 1 }
    return freq
}

// Usage:
let freq = buildFrequency([3, 4, 1, 2, 1, 5, 6], maxVal: 6)
print(freq[1]) // 2 — '1' appeared twice
print(freq[3]) // 1 — '3' appeared once
```

---

### Character — Frequency on a String

```swift
// O(n) build | O(1) query | O(26) space
func buildCharFrequency(_ s: String) -> [Int] {
    var freq = [Int](repeating: 0, count: 26)
    let a = Int(Character("a").asciiValue!)
    for ch in s { freq[Int(ch.asciiValue!) - a] += 1 }
    return freq
}
```

---

### Reconstructing a Sorted String from Frequencies

```swift
// O(n) — no comparison sort needed
func sortedFromFrequency(_ freq: [Int]) -> String {
    let a = Int(Character("a").asciiValue!)
    var result = ""
    for i in 0..<26 {
        for _ in 0..<freq[i] {
            result.append(Character(UnicodeScalar(a + i)!))
        }
    }
    return result
}
```

---

## Practice Problems

### Codeforces

| Done                                          | Problem                                                                                | Notes                                                                   |
| :-------------------------------------------- | :------------------------------------------------------------------------------------- | :---------------------------------------------------------------------- |
| <input type="checkbox" unchecked id="1eb9f4"> | [V. Frequency Array](https://codeforces.com/group/MWSDmqGsZm/contest/219774/problem/V) | The canonical problem — build a freq array and print counts from 1 to M |
| <input type="checkbox" unchecked id="5fc070"> | [J. Lucky Array](https://codeforces.com/group/MWSDmqGsZm/contest/219774/problem/J)     | Find the min element, check if its frequency is odd                     |

### LeetCode

| Done                                          | Problem                                                                                                             | Difficulty |
| :-------------------------------------------- | :------------------------------------------------------------------------------------------------------------------ | :--------- |
| <input type="checkbox" unchecked id="2dbe6b"> | [1636. Sort Array by Increasing Frequency](https://leetcode.com/problems/sort-array-by-increasing-frequency/)       | **Easy**   |
| <input type="checkbox" unchecked id="545e9b"> | [3692. Majority Frequency Characters](https://leetcode.com/problems/majority-frequency-characters/)                 | **Easy**   |
| <input type="checkbox" unchecked id="cc4aaa"> | [3005. Count Elements With Maximum Frequency](https://leetcode.com/problems/count-elements-with-maximum-frequency/) | **Easy**   |
| <input type="checkbox" unchecked id="bd401b"> | [2423. Remove Letter To Equalize Frequency](https://leetcode.com/problems/remove-letter-to-equalize-frequency/)     | **Easy**   |

### VJudge Sheet

| Done                                          | Sheet                                                           |
| :-------------------------------------------- | :-------------------------------------------------------------- |
| <input type="checkbox" unchecked id="598b58"> | [Sheet #5 — Frequency Array](https://vjudge.net/contest/547341) |