enum StackError: Error {
    case overflow
    case underflow
}

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
    try fixedStack.push(4)  // throws overflow
} catch StackError.overflow {
    print("Stack is full")  // Stack is full
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
    try fixedStack.pop()  // throws underflow
} catch StackError.underflow {
    print("Stack is empty")  // Stack is empty
}
