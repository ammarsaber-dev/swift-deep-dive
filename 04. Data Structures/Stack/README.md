# Stack

## What is it?

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


### Dynamic Stack

```swift
struct DynamicStack<T> {
    private var storage: [T] = []

    init() {}

    init(_ elements: [T]) {
        storage = elements
    }

    var isEmpty: Bool {
        // peek() == nil
        storage.isEmpty
    }

    mutating func push(_ item: T) {
        storage.append(item)
    }

    @discardableResult
    mutating func pop() -> T? {
        storage.popLast()
    }

    mutating func removeAll() {
        storage.removeAll()
    }

    func peek() -> T? {
        storage.last
    }

}
```

### Static Stack (Fixed Size Stack)

```swift
enum StackError: Error {
    case overflow
    case underflow
}

struct StaticStack<T> {
    private var storage: [T] = []
    let capacity: Int

    init(capacity: Int) {
        self.capacity = capacity
    }

    var isEmpty: Bool {
        // peek() == nil
        storage.isEmpty
    }

    mutating func push(_ item: T) throws {
        // Prevent pushing if we hit our limit
        guard storage.count < capacity else {
            throw StackError.overflow
        }

        storage.append(item)
    }

    @discardableResult
    mutating func pop() throws -> T? {
        // Prevent popping if it's already empty
        guard let item = storage.popLast() else {
            throw StackError.underflow
        }

        return item
    }

    mutating func removeAll() {
        storage.removeAll()
    }

    func peek() -> T? {
        storage.last
    }
}
```