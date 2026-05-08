# Static Array

## What is it?
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
| Search (by value)  | O(n)            | Must scan each element linearly                    |

## Space Complexity

| Aspect                | Complexity |
| --------------------- | ---------- |
| Storage               | O(n)       |
| Extra operation space | O(1)       |

## When to Use It
Static arrays work well when the maximum number of elements is known beforehand, predictable memory usage matters, fast index access is required, and resizing is unnecessary.

## Limitations
- Fixed capacity with no way to resize
- Ordered insertion and deletion are expensive due to shifting
- Search is always linear — O(n). A sorted array would allow binary search at O(log n), but that's a separate concern.

## Implementation (Swift)

```swift
import Foundation

struct StaticArray<T> {

    // Internal storage.
    //
    // We use [T?] instead of [T] because:
    // - the array starts empty
    // - unused slots need a value
    // - nil represents an unused position
    //
    // Example:
    // capacity = 5
    //
    // [10, 20, nil, nil, nil]
    //
    private var storage: [T?]

    // Number of actual stored elements.
    //
    // Example:
    // [10, 20, nil, nil, nil]
    // count = 2
    //
    private(set) var count: Int = 0

    // Maximum number of elements allowed.
    //
    // This never changes after initialization.
    //
    let capacity: Int

    // MARK: - State

    // True when the array has no elements.
    // O(1)
    //
    var isEmpty: Bool {
        count == 0
    }

    // True when no more elements can be inserted.
    // O(1)
    //
    var isFull: Bool {
        count == capacity
    }

    // MARK: - Initialization

    init(capacity: Int) {

        // Save fixed maximum capacity.
        self.capacity = capacity

        // Create the underlying storage.
        //
        // Example for capacity = 5:
        //
        // [nil, nil, nil, nil, nil]
        //
        self.storage = [T?](repeating: nil, count: capacity)
    }

    // MARK: - Subscript

    // Allows:
    //
    // arr[0]
    // arr[2] = 99
    //
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

    // MARK: - Insert

    // Inserts while preserving order.
    //
    // Example:
    //
    // Before:
    // [10, 20, 30, nil, nil]
    //
    // insert(15, at: 1)
    //
    // Shift elements right:
    // [10, 20, 20, 30, nil]
    //
    // Place new value:
    // [10, 15, 20, 30, nil]
    //
    // O(n)
    //
    mutating func insert(_ value: T, at index: Int) {

        guard count < capacity else { return }
        guard index >= 0 && index <= count else { return }

        for i in stride(from: count, to: index, by: -1) {
            storage[i] = storage[i - 1]
        }

        storage[index] = value
        count += 1
    }

    // MARK: - Append

    // Adds element at the end.
    //
    // Example:
    //
    // Before:
    // [10, 20, nil, nil]
    //
    // append(30)
    //
    // After:
    // [10, 20, 30, nil]
    //
    // O(1)
    //
    mutating func append(_ value: T) {

        guard count < capacity else { return }
        storage[count] = value
        count += 1
    }

    // MARK: - Ordered Delete

    // Deletes while preserving order.
    //
    // Example:
    //
    // Before:
    // [10, 20, 30, 40, nil]
    //
    // delete(at: 1)
    //
    // Shift left:
    // [10, 30, 40, 40, nil]
    //
    // Cleanup:
    // [10, 30, 40, nil, nil]
    //
    // O(n)
    //
    mutating func delete(at index: Int) {

        guard index >= 0 && index < count else { return }

        for i in index..<(count - 1) {
            storage[i] = storage[i + 1]
        }

        count -= 1
        storage[count] = nil
    }

    // MARK: - Remove Last

    // Removes the final element.
    //
    // Example:
    //
    // Before:
    // [10, 20, 30, nil]
    //
    // removeLast()
    //
    // After:
    // [10, 20, nil, nil]
    //
    // O(1)
    //
    @discardableResult
    mutating func removeLast() -> T? {

        guard count > 0 else { return nil }

        count -= 1
        let removed = storage[count]
        storage[count] = nil
        return removed
    }

    // MARK: - Search

    // Linear search using a closure predicate.
    //
    // Examples:
    //
    // arr.search { $0 == 20 }
    // arr.search { $0 > 50 }
    // arr.search { $0.name == "Ali" }
    //
    // O(n)
    //
    func search(where predicate: (T) -> Bool) -> Int? {

        for i in 0..<count {
            if let element = storage[i], predicate(element) {
                return i
            }
        }

        return nil
    }
}

// MARK: - Pretty Printing

extension StaticArray: CustomStringConvertible {

    // Allows:
    //
    // print(arr)
    //
    // Output:
    // [10, 20, 30]
    //
    var description: String {
        let elements = storage[..<count]
            .compactMap { $0 }
            .map(String.init(describing:))
            .joined(separator: ", ")
        return "[\(elements)]"
    }
}
```

## Swift's Built-in Static Array (`InlineArray`)

This implementation simulates static array behavior using Swift's built-in `Array` while manually enforcing fixed-capacity semantics. Swift's standard `Array` is actually a dynamic array — heap allocated, automatically resized, and copy-on-write optimized.

`InlineArray`, introduced in modern Swift, is closer to a true static array. Its size is fixed at compile time, elements are stored inline, and no dynamic resizing occurs — making it more predictable in terms of memory.

```swift
let numbers: InlineArray<4, Int> = [1, 2, 3, 4]
```

[Apple InlineArray Documentation →](https://developer.apple.com/documentation/swift/inlinearray)