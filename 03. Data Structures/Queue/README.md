# Queue

A linear data structure that follows FIFO — First In, First Out. The first element added is the first one to be removed. Think of a line at a coffee shop — the first person in line is the first one served.

A queue restricts access to two ends: elements are added to the back and removed from the front.

---
## Structure & Properties

- Backed internally by an array
- Elements enter from the back and leave from the front
- Only the front element is ever directly accessible
- Space complexity is O(n) — one slot per element, no extra overhead

## Core Operations

|Operation|Time Complexity|Return Type|Notes|
|---|---|---|---|
|enqueue|O(1)|Void|Dynamic variant; static variant returns Bool|
|dequeue|O(1)|T?|Returns nil when the queue is empty|
|peek|O(1)|T?|Returns nil when the queue is empty|
|isEmpty|O(1)|Bool|Checks if the queue has no elements|

---

## When to Use It

- **Task scheduling** — jobs processed in the order they arrive
- **Breadth-first search (BFS)** — explores nodes level by level
- **Network request handling** — requests queued and served in order
- **Any problem requiring processing in arrival order**

---

## Limitations

- No random access — can only interact with the front and back
- No iteration without dequeueing

---

## Implementation (Swift)

### Dynamic Queue

Grows as needed — no fixed capacity. Uses a `head` index to achieve O(1) dequeue without shifting, with periodic compaction to keep the backing array from growing unboundedly.

```swift
struct DynamicQueue<T> {
    private var storage: [T] = []
    // Normally, removing from the front means shifting every element left — O(n).
    // Instead, we just slide this marker forward. Everything before head is
    // treated as "removed" even though it's still sitting in memory.
    private var head: Int = 0

    init() {}
    // First element becomes the front of the queue.
    init(_ elements: [T]) {
        storage = elements
    }

    var isEmpty: Bool {
        head >= storage.count
    }

    var count: Int {
        storage.count - head
    }

    mutating func enqueue(_ item: T) {
        storage.append(item)
    }

    // Skips the expensive shift by reading storage[head] and advancing the
    // head marker — O(1).
    //
    // The trade-off: consumed elements pile up before head, wasting memory.
    // Once head passes the halfway point, we finally do a bulk cleanup with
    // removeFirst(head), reclaiming all that space at once.
    // This keeps dequeue fast (amortized O(1)) while keeping memory in check.
    // Returns nil when the queue is empty.
    @discardableResult
    mutating func dequeue() -> T? {
        guard !isEmpty else { return nil }

        let item = storage[head]
        head += 1

        // Say we enqueued 10 items then dequeued 6:
        //   storage = [a, b, c, d, e, f, g, h, i, j], head = 6
        // Six dead elements (a-f) sit before head — over half the array.
        // removeFirst(head) chops them off → [g, h, i, j], head resets to 0.
        if head > storage.count / 2 {
            storage.removeFirst(head)
            head = 0
        }

        return item
    }

    func peek() -> T? {
        guard !isEmpty else { return nil }
        return storage[head]
    }

    mutating func removeAll() {
        storage.removeAll()
        head = 0
    }
}

// Usage
var dynamic = DynamicQueue([1, 2, 3])

dynamic.enqueue(4)

if let item = dynamic.dequeue() {
    print(item)  // 1
}
if let item = dynamic.dequeue() {
    print(item)  // 2
}

if let item = dynamic.peek() {
    print(item)  // 3
}

dynamic.removeAll()

if let item = dynamic.dequeue() {
    print(item)
} else {
    print("Queue is empty")  // Queue is empty
}
```

### Static Queue

Fixed capacity — enqueue returns false when full. Uses a circular buffer over a fixed-size `[T?]` array — no compaction needed, every slot is reused.

```swift
struct StaticQueue<T> {
    private var storage: [T?]
    private var head: Int = 0
    private(set) var count: Int = 0
    let capacity: Int

    init(capacity: Int) {
        self.capacity = capacity
        self.storage = [T?](repeating: nil, count: capacity)
    }

    var isEmpty: Bool { count == 0 }
    var isFull: Bool { count == capacity }

    @discardableResult
    mutating func enqueue(_ item: T) -> Bool {
        guard !isFull else { return false }
        let index = (head + count) % capacity
        storage[index] = item
        count += 1
        return true
    }

    @discardableResult
    mutating func dequeue() -> T? {
        guard !isEmpty else { return nil }
        let item = storage[head]
        storage[head] = nil
        head = (head + 1) % capacity
        count -= 1
        return item
    }

    func peek() -> T? {
        guard !isEmpty else { return nil }
        return storage[head]
    }

    mutating func removeAll() {
        storage = [T?](repeating: nil, count: capacity)
        head = 0
        count = 0
    }
}

// Usage
var fixedQueue = StaticQueue<Int>(capacity: 3)

fixedQueue.enqueue(1)
fixedQueue.enqueue(2)
fixedQueue.enqueue(3)

if !fixedQueue.enqueue(4) {
    print("Queue is full!")  // Queue is full!
}

if let item = fixedQueue.peek() {
    print(item)  // 1
}

if let item = fixedQueue.dequeue() {
    print(item)  // 1
}
if let item = fixedQueue.dequeue() {
    print(item)  // 2
}

fixedQueue.removeAll()

if let item = fixedQueue.dequeue() {
    print(item)
} else {
    print("Queue is empty")  // Queue is empty
}
```
