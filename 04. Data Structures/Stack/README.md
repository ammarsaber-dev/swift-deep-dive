# Stack

A linear data structure that follows LIFO — Last In, First Out. The last element pushed onto the stack is the first one to be popped off. Think of a physical stack of objects like pancakes or books — you can only ever interact with the top item.

Unlike arrays, a stack enforces how you access your data. You can't reach into the middle — everything goes through the top.

---
## Structure & Properties

- Backed internally by an array
- `append()` adds to the top, `popLast()` removes from the top — both O(1)
- Only the top element is ever directly accessible
- Space complexity is O(n) — one slot per element, no extra overhead

## Core Operations

|Operation|Time Complexity|Return Type|Notes|
|---|---|---|---|
|push|O(1)|Void|Dynamic variant; static variant returns Bool|
|pop|O(1)|T?|Returns nil when the stack is empty|
|peek|O(1)|T?|Returns nil when the stack is empty|
|isEmpty|O(1)|Bool|Checks if the stack has no elements|
|count|O(1)|Int|Number of elements currently in the stack|

---

## When to Use It

- **Undo / redo** — each action is pushed, undoing pops the last one
- **Backtracking** — maze solving and DFS push decision points and pop on dead ends
- **Call stack** — memory management at the architectural level uses this exact model
- **Any problem requiring reversal** — processing things in the opposite order they arrived

---

## Limitations

- No random access — can't read a specific index without popping everything above it
- No iteration — exposing elements via subscript or iterators defeats the purpose
- Linear search — finding a value requires popping until a match is found

---

## Implementation (Swift)

### Dynamic Stack

Grows as needed — no fixed capacity.

```swift
struct DynamicStack<T> {

    private var storage: [T] = []

    init() {}

    init(_ elements: [T]) {
        storage = elements
    }

    var isEmpty: Bool {
        storage.isEmpty
    }

    var count: Int {
        storage.count
    }

    mutating func push(_ item: T) {
        storage.append(item)
    }

    @discardableResult
    mutating func pop() -> T? {
        storage.popLast()
    }

    func peek() -> T? {
        storage.last
    }

    mutating func removeAll() {
        storage.removeAll()
    }
}

// Usage
var dynamic = DynamicStack([1, 2, 3])

print(dynamic.peek() ?? "empty")  // 3
dynamic.push(4)

if let item = dynamic.pop() {
    print(item)  // 4
}
if let item = dynamic.pop() {
    print(item)  // 3
}

dynamic.removeAll()

if let item = dynamic.pop() {
    print(item)
} else {
    print("Stack is empty")  // Stack is empty
}
```

### Static Stack

Fixed capacity — push returns false when full. Backed by a fixed-size `[T?]` array — no dynamic resizing.

```swift
struct StaticStack<T> {
    private var storage: [T?]
    private(set) var count: Int = 0
    let capacity: Int

    init(capacity: Int) {
        self.capacity = capacity
        self.storage = [T?](repeating: nil, count: capacity)
    }

    var isEmpty: Bool { count == 0 }
    var isFull: Bool { count == capacity }

    @discardableResult
    mutating func push(_ item: T) -> Bool {
        guard !isFull else { return false }
        storage[count] = item
        count += 1
        return true
    }

    @discardableResult
    mutating func pop() -> T? {
        guard !isEmpty else { return nil }
        count -= 1
        let item = storage[count]
        storage[count] = nil
        return item
    }

    func peek() -> T? {
        guard !isEmpty else { return nil }
        return storage[count - 1]
    }

    mutating func removeAll() {
        storage = [T?](repeating: nil, count: capacity)
        count = 0
    }
}

// Usage
var fixedStack = StaticStack<Int>(capacity: 3)

fixedStack.push(1)
fixedStack.push(2)
fixedStack.push(3)

if !fixedStack.push(4) {
    print("Stack is full")  // Stack is full
}

print(fixedStack.peek() ?? "empty")  // 3

if let item = fixedStack.pop() {
    print(item)  // 3
}
if let item = fixedStack.pop() {
    print(item)  // 2
}

fixedStack.removeAll()

if let item = fixedStack.pop() {
    print(item)
} else {
    print("Stack is empty")  // Stack is empty
}
```
