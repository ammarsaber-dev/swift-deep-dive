# Stack

A linear data structure that follows LIFO — Last In, First Out. The last element pushed onto the stack is the first one to be popped off. Think of a physical stack of objects like pancakes or books — you can only ever interact with the top item.

Unlike arrays, a stack enforces how you access your data. You can't reach into the middle — everything goes through the top.

## Structure & Properties

- Backed internally by an array
- `append()` adds to the top, `popLast()` removes from the top — both O(1)
- Only the top element is ever directly accessible
- Space complexity is O(n) — one slot per element, no extra overhead

## Core Operations

|Operation|Time Complexity|Notes|
|---|---|---|
|push|O(1)|Appends to the end of the backing array|
|pop|O(1)|Removes and returns the top element|
|peek|O(1)|Returns the top element without removing it|
|isEmpty|O(1)|Checks if the stack has no elements|

## When to Use It

- **Undo / redo** — each action is pushed, undoing pops the last one
- **Backtracking** — maze solving and DFS push decision points and pop on dead ends
- **Call stack** — memory management at the architectural level uses this exact model
- **Any problem requiring reversal** — processing things in the opposite order they arrived

## Limitations

- No random access — can't read a specific index without popping everything above it
- No iteration — exposing elements via subscript or iterators defeats the purpose
- Linear search — finding a value requires popping until a match is found

## Implementation (Swift)

Both stack variants share the same error type — defined once here and used across both implementations.

```swift
enum StackError: Error {
    case overflow  // Attempted to push onto a full stack
    case underflow // Attempted to pop from an empty stack
}
```

### Dynamic Stack

Grows as needed — no fixed capacity.

```swift
struct DynamicStack<T> {

    // Backing array. append() = push, popLast() = pop — both O(1).
    private var storage: [T] = []

    init() {}

    // Initialize from an existing array. Last element becomes the top.
    init(_ elements: [T]) {
        storage = elements
    }

    // True when the stack has no elements.
    var isEmpty: Bool {
        peek() == nil
    }

    // Adds an element to the top.
    mutating func push(_ item: T) {
        storage.append(item)
    }

    // Removes and returns the top element. Throws underflow if empty.
    @discardableResult
    mutating func pop() throws -> T {
        guard let item = storage.popLast() else { throw StackError.underflow }
        return item
    }

    // Returns the top element without removing it. Returns nil if empty.
    func peek() -> T? {
        storage.last
    }

    // Removes all elements.
    mutating func removeAll() {
        storage.removeAll()
    }
}

// Usage
var dynamic = DynamicStack([1, 2, 3])

print(dynamic.peek() ?? "empty")  // 3
dynamic.push(4)

do {
    print(try dynamic.pop())      // 4
    print(try dynamic.pop())      // 3
} catch StackError.underflow {
    print("Stack is empty")
}

dynamic.removeAll()

do {
    try dynamic.pop()             // throws underflow
} catch StackError.underflow {
    print("Stack is empty")      // Stack is empty
}
```

### Static Stack

Fixed capacity — throws on overflow or underflow.

```swift
struct StaticStack<T> {

    // Backing array. append() = push, popLast() = pop — both O(1).
    private var storage: [T] = []
    let capacity: Int

    init(capacity: Int) {
        self.capacity = capacity
    }

    // True when the stack has no elements.
    var isEmpty: Bool {
        peek() == nil
    }

    // Adds an element to the top. Throws overflow if capacity is reached.
    mutating func push(_ item: T) throws {
        guard storage.count < capacity else { throw StackError.overflow }
        storage.append(item)
    }

    // Removes and returns the top element. Throws underflow if empty.
    @discardableResult
    mutating func pop() throws -> T {
        guard let item = storage.popLast() else { throw StackError.underflow }
        return item
    }

    // Returns the top element without removing it. Returns nil if empty.
    func peek() -> T? {
        storage.last
    }

    // Removes all elements.
    mutating func removeAll() {
        storage.removeAll()
    }
}

// Usage
var fixedStack = StaticStack<Int>(capacity: 3)

do {
    try fixedStack.push(1)
    try fixedStack.push(2)
    try fixedStack.push(3)
    try fixedStack.push(4)       // throws overflow
} catch StackError.overflow {
    print("Stack is full")       // Stack is full
}

print(fixedStack.peek() ?? "empty")  // 3

do {
    print(try fixedStack.pop())  // 3
    print(try fixedStack.pop())  // 2
} catch StackError.underflow {
    print("Stack is empty")
}

fixedStack.removeAll()

do {
    try fixedStack.pop()         // throws underflow
} catch StackError.underflow {
    print("Stack is empty")      // Stack is empty
}
```