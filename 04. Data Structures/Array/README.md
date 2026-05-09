# Array

A collection of elements stored in contiguous memory, each accessible by a unique index. Arrays come in two flavors — static (fixed size) and dynamic (resizable) — with different trade-offs in memory and performance.

---

## Static Array

A fixed-size collection. Capacity is decided at initialization and cannot change afterward, though stored values can still be modified.

### Structure & Properties
- Each element identified by a unique index, from `0` up to `count - 1`
- Memory is contiguous — any element's address is computed directly from its index
- Capacity is fixed after initialization
- Space complexity is O(n) — one slot per element, no extra overhead

### Core Operations

| Operation        | Time Complexity | Return Type | Notes                                             |
| ---------------- | --------------- | ----------- | ------------------------------------------------- |
| Read / Write     | O(1)            | T?          | Subscript returns nil when index is out of bounds |
| Insert (middle)  | O(n)            | Bool        | Returns false when full or index is invalid       |
| Insert (end)     | O(1)            | Bool        | Returns false when full                           |
| Delete (ordered) | O(n)            | Bool        | Returns false when index is invalid               |
| Remove Last      | O(1)            | T?          | Returns nil when empty                            |

### When to Use It
Best when the maximum number of elements is known beforehand, predictable memory usage matters, and resizing is unnecessary.

### Limitations
- Fixed capacity with no way to resize
- Ordered insertion and deletion are expensive due to shifting

### Implementation (Swift)

```swift
struct StaticArray<T> {

    private var storage: [T?]
    private(set) var count: Int = 0
    let capacity: Int

    var isEmpty: Bool { count == 0 }
    var isFull: Bool { count == capacity }

    // Fills a fixed-size backing array with nil.
    // capacity = 3 → storage = [nil, nil, nil]
    init(capacity: Int) {
        self.capacity = capacity
        self.storage = [T?](repeating: nil, count: capacity)
    }

    // Direct index-based read/write — O(1).
    // arr[0] reads the first element; arr[1] = 5 overwrites the second.
    // Returns nil / silently ignores when index >= count.
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

    // Shifts elements right from the target index, then places the new value.
    // [10, 20, 30, nil, nil] → insert(15, at: 1) → [10, 15, 20, 30, nil, nil]
    // Returns false when full or index is invalid. O(n)
    @discardableResult
    mutating func insert(_ value: T, at index: Int) -> Bool {
        guard count < capacity else { return false }
        guard index >= 0 && index <= count else { return false }
        // Work backwards from the tail, sliding each element one slot right
        // to open a gap at the target index.
        for i in stride(from: count, to: index, by: -1) {
            storage[i] = storage[i - 1]
        }
        storage[index] = value
        count += 1
        return true
    }

    // Writes value at the first free slot (index == count) and increments count.
    // [10, 20, nil, nil] → append(30) → [10, 20, 30, nil]
    // Returns false when full. O(1)
    @discardableResult
    mutating func append(_ value: T) -> Bool {
        guard count < capacity else { return false }
        // count doubles as the index of the first free slot.
        storage[count] = value
        count += 1
        return true
    }

    // Shifts elements left to fill the removed slot, then nils out the tail.
    // [10, 20, 30, nil] → delete(at: 0) → [20, 30, nil, nil]
    // Returns false when index is invalid. O(n)
    @discardableResult
    mutating func delete(at index: Int) -> Bool {
        guard index >= 0 && index < count else { return false }
        // Work forwards from the target, sliding each element one slot left
        // to close the gap left by the removed element.
        for i in index..<(count - 1) {
            storage[i] = storage[i + 1]
        }
        count -= 1
        // Wipe the now-unused slot so we don't hold a stale reference.
        storage[count] = nil
        return true
    }

    // Decrements count, nils the vacated slot, returns the removed value.
    // [10, 20, 30, nil] → removeLast() → returns 30, storage = [10, 20, nil, nil]
    // Returns nil when empty. O(1)
    @discardableResult
    mutating func removeLast() -> T? {
        guard count > 0 else { return nil }
        count -= 1
        // count now points at the last active element (before it was the
        // first free slot). Grab it, then nil the slot.
        let removed = storage[count]
        storage[count] = nil
        return removed
    }
}

extension StaticArray: CustomStringConvertible {
    // Formats the active elements like a real array for printing.
    // storage = [10, 15, nil, nil], count = 2 → "[10, 15]"
    var description: String {
        let elements = storage[..<count]
            .compactMap { $0 }
            .map(String.init(describing:))
            .joined(separator: ", ")
        return "[\(elements)]"
    }
}

var arr = StaticArray<Int>(capacity: 5)

arr.append(10)
arr.append(20)
arr.append(30)
print(arr)              // [10, 20, 30]

arr.insert(15, at: 1)
print(arr)              // [10, 15, 20, 30]

arr.delete(at: 0)
print(arr)              // [15, 20, 30]

if let last = arr.removeLast() {
    print(last)         // 30
}
print(arr)              // [15, 20]

if let val = arr[0] {
    print(val)          // 15
}
print(arr.isEmpty)      // false
print(arr.isFull)       // false
```

## Swift's True Static Array — `InlineArray`

`InlineArray`, introduced in modern Swift, is the closest Swift gets to a true static array. Unlike `Array`, its size is fixed at compile time, elements are stored inline on the stack (no heap allocation), and no dynamic resizing occurs.

```swift
let numbers: InlineArray<4, Int> = [1, 2, 3, 4]
```

[Apple InlineArray Documentation →](https://developer.apple.com/documentation/swift/inlinearray)

---

## Dynamic Array

A resizable collection that grows automatically as elements are added. This is Swift's built-in `Array` type.

### Structure & Properties
- Backed by a heap-allocated contiguous buffer
- When capacity is exceeded, a new larger buffer is allocated and elements are copied over
- Swift doubles capacity each time it resizes — this geometric growth makes append amortized O(1)
- Uses copy-on-write (COW) — two arrays sharing the same storage only diverge into separate copies at the moment one is modified
- Space complexity is O(n)

### Core Operations

| Operation        | Time Complexity | Notes                                        |
| ---------------- | --------------- | -------------------------------------------- |
| Read / Write     | O(1)            | Direct index access                          |
| Append           | O(1) amortized  | Occasionally O(n) when a resize is triggered |
| Insert (middle)  | O(n)            | Requires shifting elements right             |
| Delete (ordered) | O(n)            | Requires shifting elements left              |
| Remove Last      | O(1)            | No shifting needed                           |

### When to Use It
Best when the number of elements isn't known ahead of time and you need a general-purpose collection. This is the default choice in Swift for most use cases.

### Limitations
- Resize events copy the entire buffer — O(n) occasionally
- Insertion and deletion in the middle are expensive due to shifting
- Up to 2x allocated memory may be unused after a resize

### Implementation (Swift)

A custom dynamic array that starts with capacity 4 and doubles when full.

```swift
struct DynamicArray<T> {

    private var storage: [T?]
    private(set) var count: Int = 0
    private(set) var capacity: Int

    var isEmpty: Bool { count == 0 }
    var isFull: Bool { count == capacity }

    init() {
        capacity = 4
        storage = [T?](repeating: nil, count: capacity)
    }

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

    mutating func append(_ value: T) {
        if count == capacity { resize() }
        storage[count] = value
        count += 1
    }

    @discardableResult
    mutating func insert(_ value: T, at index: Int) -> Bool {
        guard index >= 0 && index <= count else { return false }
        if count == capacity {
            resize()
        }
        for i in stride(from: count, to: index, by: -1) {
            storage[i] = storage[i - 1]
        }
        storage[index] = value
        count += 1
        return true
    }

    @discardableResult
    mutating func delete(at index: Int) -> Bool {
        guard index >= 0 && index < count else { return false }
        for i in index..<(count - 1) {
            storage[i] = storage[i + 1]
        }
        count -= 1
        storage[count] = nil
        return true
    }

    @discardableResult
    mutating func removeLast() -> T? {
        guard count > 0 else { return nil }
        count -= 1
        let removed = storage[count]
        storage[count] = nil
        return removed
    }

    mutating func removeAll() {
        storage = [T?](repeating: nil, count: capacity)
        count = 0
    }

    // Doubles capacity by allocating a new buffer and copying elements over.
    // This occasional O(n) copy makes append O(1) amortized.
    private mutating func resize() {
        let newCapacity = capacity * 2
        var newStorage = [T?](repeating: nil, count: newCapacity)
        for i in 0..<count {
            newStorage[i] = storage[i]
        }
        storage = newStorage
        capacity = newCapacity
    }
}

extension DynamicArray: CustomStringConvertible {
    var description: String {
        let elements = storage[..<count]
            .compactMap { $0 }
            .map(String.init(describing:))
            .joined(separator: ", ")
        return "[\(elements)]"
    }
}

var dynamic = DynamicArray<Int>()

dynamic.append(10)
dynamic.append(20)
dynamic.append(30)
print(dynamic)              // [10, 20, 30]

dynamic.insert(15, at: 1)
print(dynamic)              // [10, 15, 20, 30]

dynamic.delete(at: 0)
print(dynamic)              // [15, 20, 30]

if let last = dynamic.removeLast() {
    print(last)             // 30
}
print(dynamic)              // [15, 20]

if let val = dynamic[0] {
    print(val)              // 15
}
print(dynamic.isEmpty)      // false
print(dynamic.capacity)     // 4 — no resize needed for 3 elements
```

---

## Static vs Dynamic — At a Glance

| | Static Array | Dynamic Array (`Array`) | InlineArray |
|---|---|---|---|
| Size | Fixed at init | Grows automatically | Fixed at compile time |
| Memory | Predictable, fixed memory | Heap-allocated | Stored inline on the stack |
| Append | O(1) if not full, fails if full | O(1) amortized | N/A (fixed size) |
| Best for | Known size, tight memory control | General purpose | Max size known at compile time |