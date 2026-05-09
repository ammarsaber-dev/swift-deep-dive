# Prefix Sum

#algorithm #technique #array #range-query #offline-queries

> Precompute the past. Answer the future in O(1).

---

## Contents

- [[#The Core Idea]]
- [[#How It Works]]
- [[#The Formula]]
- [[#The Off-by-One Trap]]
- [[#Performance Complexity]]
- [[#Not Just Numbers — Prefix Sum on Characters]]
- [[#What Prefix Sum Can and Can't Do]]
- [[#Edge Cases to Know]]
- [[#When to Actually Use It]]
- [[#Implementation]]

---

## The Core Idea

You have an array and you're receiving many queries — each one asking: _"what is the sum of all elements between index L and index R?"_

The naive answer is to loop through the range every time. That's O(n) per query. With Q queries, you're at O(n × Q). For large inputs, that won't pass.

The observation that unlocks everything: **the array isn't changing between queries.** The sum from index 0 to index 5 will always be the same number — so why recompute it every time someone asks?

The prefix sum is the answer. Walk the array once, and at every position store the **running total from the beginning up to that point**. Now the sum of any range is just the difference between two of those stored totals — answered in a single subtraction.

Think of it like a bank statement. Instead of adding up every transaction each time you want your balance, you just look at the running total column.

> [!info] Prefix Sum is built on top of a standard [[04. Data Structures/Array/README.md|Array]] — the O(1) random access it provides is what makes range queries fast.

---

## How It Works

Define `prefix[k]` as **the sum of the first k elements** — that is, from index 0 up to index k-1.

```
array:   [3, 2, 1, 3, 1, 3, 3]
          0  1  2  3  4  5  6   ← indices

prefix:  [0, 3, 5, 6, 9, 10, 13, 16]
          0  1  2  3  4   5   6   7  ← indices
```

The leading `0` represents the sum of an empty prefix — the sum of the first _zero_ elements. This is not a trick; it's the definition. And it cleanly handles the edge case where the range starts at index 0.

Notice the pattern: each element of `prefix` is the previous element plus one more value from the array. That means the whole array builds with a single loop.

---

## The Formula

**Building prefix:**

```
prefix[0] = 0
prefix[i] = prefix[i - 1] + a[i - 1]
```

**Answering a range query from L to R (1-indexed):**

```
sum(L, R) = prefix[R] - prefix[L - 1]
```

**Answering a range query from L to R (0-indexed):**

```
sum(L, R) = prefix[R + 1] - prefix[L]
```

The intuition: `prefix[R+1]` holds the sum of everything from the start up to R. `prefix[L]` holds the sum of everything before L. Their difference is exactly the sum of the range in between.

> [!tip] If you ever forget the formula, go back to the definition. `prefix[k]` = sum of first k elements. From that single sentence, you can re-derive the range query formula from scratch every time.

---

## The Off-by-One Trap

The leading zero in the prefix array exists precisely to avoid an out-of-bounds case. Without it, the formula `prefix[L - 1]`would require accessing index `-1` when L is 0.

By prepending a zero, the prefix array has size `n + 1` and every index access is always valid — including queries that start at the very beginning of the array.

> [!warning] Always declare the prefix array with size `n + 1`, not `n`. Forgetting this is the single most common implementation bug with this technique.

---

## Performance Complexity

|Phase|Time|Space|
|---|---|---|
|Building the prefix array|O(n)|O(n)|
|Single range query|O(1)|—|
|Q queries total|O(n + Q)|O(n)|

Compare that to the brute-force O(n × Q). The preprocessing cost is O(n), paid once. Every query after that costs nothing.

> [!warning] Prefix sums accumulate large values fast. If your array has n = 10⁵ elements each up to 10⁹, the prefix sum can reach 10¹⁴ — well beyond `Int32`'s limit of ~2.1 × 10⁹. **Always use `Int64` (or `long long` in C++) for the prefix array.**

---

## Not Just Numbers — Prefix Sum on Characters

Prefix sum isn't limited to integers. You can apply it to **character frequencies** — and this unlocks fast answers to queries like _"what is the most common character between index L and R?"_

The idea: for each of the 26 letters, build a separate prefix sum array where each position stores how many times that letter has appeared so far. Then for any query range, the frequency of character `c` is just:

```
freq(c, L, R) = charPrefix[c][R + 1] - charPrefix[c][L]
```

This turns a potentially O(n × 26) per query into O(26) per query — constant time in terms of n.

> [!note] This generalizes further. Prefix sums work on any property that can be expressed as a sum of 0s and 1s — "does this element equal X?" is 1 or 0, so its prefix sum gives you the count of X in any range.

---

## What Prefix Sum Can and Can't Do

Prefix sum works because **addition has an inverse** — subtraction. That's what makes the range formula possible: you take the longer prefix and subtract the shorter one.

This means it works for:

- **Sum** — the classic case
- **XOR** — XOR is its own inverse (`a XOR a = 0`)
- **Product** — divide the longer prefix by the shorter one (only if no zeros exist)
- **Frequency counts** — frequency is just a sum of 1s

It does **not** work for:

- **Maximum / Minimum** — no inverse operation exists. Knowing the max of a longer range and the max of a shorter range tells you nothing about the max of the difference. For range maximum queries, you need a Segment Tree or Sparse Table.

> [!note] A prefix maximum array can still be useful — just not for answering range max queries. It's used in problems like _"what is the largest element to the left of index i?"_ — that's a prefix query, not a range query.

---

## Edge Cases to Know

|Scenario|Expected|Notes|
|---|---|---|
|Range starting at index 0|`prefix[R + 1] - prefix[0]` = `prefix[R + 1]`|The leading zero makes this work naturally|
|Single element query (L == R)|`prefix[R + 1] - prefix[L]`|Works correctly with the standard formula|
|All elements negative|Prefix array is decreasing|The formula still works — subtraction handles it|
|Large values|Prefix can overflow `Int32`|Always use `Int64` / `long long`|
|Array doesn't change between queries|Prefix sum is valid|If the array changes, the prefix array goes stale — rebuild or use a Segment Tree|

---

## When to Actually Use It

**Use prefix sum when:**

- You have multiple range sum queries on a **static** (unchanging) array
- You need frequency counts over ranges (characters, values, etc.)
- The operation you're summing has an **inverse** (sum, XOR, product without zeros)
- You're building toward 2D prefix sum or partial sum techniques

**Don't use it when:**

- The array **changes between queries** — prefix sum doesn't support updates; use a Segment Tree or BIT instead
- You need **range maximum/minimum** — no inverse exists for those operations
- You only have **one query** — the O(n) preprocessing isn't worth it for a single answer

---

## Implementation

### Basic Prefix Sum

```swift
// O(n) build | O(1) query | O(n) space
// prefix[k] = sum of first k elements (1-indexed interface)
func buildPrefix(_ a: [Int]) -> [Int] {
    let n = a.count
    var prefix = [Int](repeating: 0, count: n + 1)  // leading 0 at index 0
    for i in 1...n {
        prefix[i] = prefix[i - 1] + a[i - 1]
    }
    return prefix
}

// Range sum query: sum of a[L...R] (0-indexed on original array)
func rangeSum(_ prefix: [Int], _ L: Int, _ R: Int) -> Int {
    return prefix[R + 1] - prefix[L]
}
```

### Character Frequency Prefix Sum

```swift
// O(26 × n) build | O(26) query — effectively O(1) in terms of n
func buildCharPrefix(_ s: String) -> [[Int]] {
    let chars = Array(s)
    let n = chars.count
    let a = Int(Character("a").asciiValue!)

    // charPrefix[c][k] = number of times character c appears in first k chars
    var charPrefix = [[Int]](repeating: [Int](repeating: 0, count: n + 1), count: 26)

    for i in 1...n {
        let c = Int(chars[i - 1].asciiValue!) - a
        for ch in 0..<26 {
            charPrefix[ch][i] = charPrefix[ch][i - 1]
        }
        charPrefix[c][i] += 1
    }
    return charPrefix
}

// Frequency of character c (0='a'..25='z') in s[L...R] (0-indexed)
func charFrequency(_ charPrefix: [[Int]], _ c: Int, _ L: Int, _ R: Int) -> Int {
    return charPrefix[c][R + 1] - charPrefix[c][L]
}
```