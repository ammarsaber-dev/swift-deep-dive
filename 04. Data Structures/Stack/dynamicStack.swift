enum StackError: Error {
    case overflow
    case underflow
}

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
    print(try dynamic.pop())  // 4
    print(try dynamic.pop())  // 3
} catch StackError.underflow {
    print("Stack is empty")
}

dynamic.removeAll()

do {
    try dynamic.pop()  // throws underflow
} catch StackError.underflow {
    print("Stack is empty")  // Stack is empty
}
