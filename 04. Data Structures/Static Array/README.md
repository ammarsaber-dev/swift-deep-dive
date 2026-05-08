# Static Array

## What is it?

A static array is a fixed-size collection stored conceptually in a contiguous block of memory.

Its capacity is decided at initialization and cannot change afterward, though the stored values themselves can still be modified.

This implementation simulates static-array behavior using Swift’s built-in `Array` type while manually enforcing fixed-capacity semantics.

Swift also provides a built-in fixed-size collection called `InlineArray`, introduced in modern Swift versions. Unlike regular `Array`, `InlineArray` stores elements inline with a fixed compile-time size and does not dynamically resize.

You can learn more here:
- [Apple InlineArray Documentation](https://developer.apple.com/documentation/swift/inlinearray?utm_source=chatgpt.com)

Example:

```swift
let numbers: InlineArray<4, Int> = [1, 2, 3, 4]
```

Unlike Swift’s normal `Array`, an `InlineArray`:

- has a fixed size
    
- stores elements inline
    
- avoids heap allocation overhead
    
- cannot grow or shrink
    

---

# Structure & Properties

- Each element is identified by a unique index
    
- Indices start at `0` and end at `count - 1`
    
- Elements are conceptually contiguous in memory
    
- Capacity is fixed after initialization
    
- Reading and writing by index is constant time (`O(1)`)
    

---

# Core Operations

| Operation             | Time Complexity | Explanation                               |
| --------------------- | --------------- | ----------------------------------------- |
| Read / Write          | O(1)            | Direct index access                       |
| Insert (middle)       | O(n)            | Elements must shift right                 |
| Insert (end / append) | O(1)            | No shifting needed                        |
| Delete (ordered)      | O(n)            | Elements must shift left                  |
| Remove Last           | O(1)            | Simply clear final slot                   |
| Search                | O(n)            | Linear scan                               |

---

# Space Complexity

|Aspect|Complexity|
|---|---|
|Storage|O(n)|
|Extra operation space|O(1)|

---

# When to Use It

Static arrays are useful when:

1. The maximum number of elements is known beforehand
    
2. Predictable memory usage is important
    
3. Fast index access is required
    
4. Resizing is unnecessary
    

They become especially efficient when element order does **not** matter.

In unordered collections:

- insertion becomes append (`O(1)`)
    
- deletion becomes overwrite-with-last (`O(1)`)

---

# Limitations

- Fixed capacity
    
- Cannot dynamically resize
    
- Ordered insertion is expensive
    
- Ordered deletion is expensive
    
- Searching is linear
    

---

# Implementation (Swift)

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
    //
    // O(1)
    //
    var isEmpty: Bool {
        count == 0
    }

    // True when no more elements can be inserted.
    //
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

        // Reading value
        get {

            // Bounds check
            guard index >= 0 && index < count else {
                return nil
            }

            // Direct access -> O(1)
            return storage[index]
        }

        // Writing value
        set {

            // Bounds check
            guard index >= 0 && index < count else {
                return
            }

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

        // Cannot exceed capacity
        guard count < capacity else {
            return
        }

        // Valid insertion range:
        // 0...count
        //
        guard index >= 0 && index <= count else {
            return
        }

        // Shift elements one position right.
        //
        // We go backwards to avoid overwriting data.
        //
        for i in stride(from: count, to: index, by: -1) {
            storage[i] = storage[i - 1]
        }

        // Insert new value
        storage[index] = value

        // One more active element
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

        // Ensure there is free space
        guard count < capacity else {
            return
        }

        // Place value at next free slot
        storage[count] = value

        // Increase logical size
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

        // Bounds check
        guard index >= 0 && index < count else {
            return
        }

        // Shift remaining elements left
        for i in index..<(count - 1) {
            storage[i] = storage[i + 1]
        }

        // Logical removal
        count -= 1

        // Clear unused slot
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

        // Cannot remove from empty array
        guard count > 0 else {
            return nil
        }

        // Move logical end backward
        count -= 1

        // Save removed value
        let removed = storage[count]

        // Clear unused slot
        storage[count] = nil

        return removed
    }

    // MARK: - Search

    // Linear search using a closure predicate.
    //
    // Examples:
    //
    // arr.search { $0 == 20 }
    //
    // arr.search { $0 > 50 }
    //
    // arr.search { $0.name == "Ali" }
    //
    // O(n)
    //
    func search(where predicate: (T) -> Bool) -> Int? {

        // Check every active element
        for i in 0..<count {

            // Ignore nil slots
            if let element = storage[i],

               // If condition matches -> return index
               predicate(element) {

                return i
            }
        }

        // No match found
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

            // Remove nils
            .compactMap { $0 }

            // Convert to String
            .map(String.init(describing:))

            // Join into single string
            .joined(separator: ", ")

        return "[\(elements)]"
    }
}
```


---

# Notes

This implementation focuses on learning how fixed-capacity arrays work internally.

Swift’s standard `Array` is actually a dynamic array:

- heap allocated
    
- automatically resized
    
- copy-on-write optimized
    

`InlineArray` is closer to a true static array because:

- size is fixed at compile time
    
- elements are stored inline
    
- no dynamic resizing occurs ([Apple Developer](https://developer.apple.com/documentation/swift/inlinearray?utm_source=chatgpt.com "InlineArray | Apple Developer Documentation"))
    

A true low-level manual static array implementation in Swift would typically use:

- `UnsafeMutablePointer`
    
- `UnsafeMutableBufferPointer`
