# Static Array

A fixed-size collection stored in a contiguous block of memory. Its capacity is decided at initialization and cannot change afterward, though the stored values themselves can still be modified.

## Structure & Properties
- Each element is identified by a unique index, starting from `0` up to `count - 1`
- Memory is contiguous, so any element's location can be computed directly via its index
- Capacity is fixed after initialization
- Space complexity is O(n) — one slot per element, no extra overhead

## Core Operations

| Operation          | Time Complexity | Notes                                              |
| ------------------ | --------------- | -------------------------------------------------- |
| Read / Write       | O(1)            | Direct index-based memory access                   |
| Insert (middle)    | O(n)            | Requires shifting subsequent elements to the right |
| Insert (end)       | O(1)            | Only possible if capacity isn't exceeded           |
| Delete (ordered)   | O(n)            | Requires shifting subsequent elements to the left  |
| Remove Last        | O(1)            | Simply clear the final slot                        |

## When to Use It
Static arrays work well when the maximum number of elements is known beforehand, predictable memory usage matters, fast index access is required, and resizing is unnecessary.

## Limitations
- Fixed capacity with no way to resize
- Ordered insertion and deletion are expensive due to shifting

## Implementation (Swift)

```swift
import Foundation

struct StaticArray<T> {

    // Internal storage using [T?] so unused slots can be nil.
    // capacity = 5 → [10, 20, nil, nil, nil]
    private var storage: [T?]

    // Number of active elements.
    // [10, 20, nil, nil, nil] → count = 2
    private(set) var count: Int = 0

    // Fixed maximum size — never changes after init.
    let capacity: Int

    // O(1)
    var isEmpty: Bool { count == 0 }

    // O(1)
    var isFull: Bool { count == capacity }

    init(capacity: Int) {
        self.capacity = capacity
        // capacity = 5 → [nil, nil, nil, nil, nil]
        self.storage = [T?](repeating: nil, count: capacity)
    }

    // arr[0], arr[2] = 99 — O(1)
    subscript(index: Int) -> T? {
        get {
            guard index >= 0 && index < count else { return nil }
            return storage[index]
        }
        set {
            guard index >= 0 && index < count else { return }
            storage[index] = newValue
        }
    }

    // Inserts while preserving order — O(n)
    // [10, 20, 30, nil, nil] → insert(15, at: 1)
    // Shift right: [10, 20, 20, 30, nil]
    // Place value: [10, 15, 20, 30, nil]
    mutating func insert(_ value: T, at index: Int) {
        guard count < capacity else { return }
        guard index >= 0 && index <= count else { return }
        for i in stride(from: count, to: index, by: -1) {
            storage[i] = storage[i - 1]
        }
        storage[index] = value
        count += 1
    }

    // Adds element at the end — O(1)
    // [10, 20, nil, nil] → append(30) → [10, 20, 30, nil]
    mutating func append(_ value: T) {
        guard count < capacity else { return }
        storage[count] = value
        count += 1
    }

    // Deletes while preserving order — O(n)
    // [10, 20, 30, 40, nil] → delete(at: 1)
    // Shift left: [10, 30, 40, 40, nil]
    // Cleanup:    [10, 30, 40, nil, nil]
    mutating func delete(at index: Int) {
        guard index >= 0 && index < count else { return }
        for i in index..<(count - 1) {
            storage[i] = storage[i + 1]
        }
        count -= 1
        storage[count] = nil
    }

    // Removes the final element — O(1)
    // [10, 20, 30, nil] → removeLast() → [10, 20, nil, nil]
    @discardableResult
    mutating func removeLast() -> T? {
        guard count > 0 else { return nil }
        count -= 1
        let removed = storage[count]
        storage[count] = nil
        return removed
    }
}

// Usage
var arr = StaticArray<Int>(capacity: 5)

arr.append(10)
arr.append(20)
arr.append(30)

arr.insert(15, at: 1)               // [10, 15, 20, 30]
arr.insert(99, at: 10)              // ignored — out of bounds
arr.append(40)
arr.append(50)
arr.append(60)                      // ignored — full

arr.delete(at: 0)                   // [15, 20, 30, 40, 50]
arr.delete(at: 99)                  // ignored — out of bounds

print(arr.removeLast() ?? "empty")  // 50
print(arr[0] ?? "empty")            // 15
print(arr[99] ?? "empty")           // empty — out of bounds

print(arr.isEmpty)                  // false
print(arr.isFull)                   // false
```

## Swift's Built-in Static Array (`InlineArray`)

This implementation simulates static array behavior using Swift's built-in `Array` while manually enforcing fixed-capacity semantics. Swift's standard `Array` is actually a dynamic array — heap allocated, automatically resized, and copy-on-write optimized.

`InlineArray`, introduced in modern Swift, is closer to a true static array. Its size is fixed at compile time, elements are stored inline, and no dynamic resizing occurs — making it more predictable in terms of memory.

```swift
let numbers: InlineArray<4, Int> = [1, 2, 3, 4]
```

[Apple InlineArray Documentation →](https://developer.apple.com/documentation/swift/inlinearray)