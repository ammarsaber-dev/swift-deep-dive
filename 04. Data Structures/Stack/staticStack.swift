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

var sStack = StaticStack<Int>(capacity: 5)

do {
    print(sStack)
    try sStack.push(1)
    try sStack.push(2)
    try sStack.push(3)
    try sStack.push(4)
    try sStack.push(5)
    print(sStack)

    let lastElement = sStack.peek()
    print(lastElement ?? "Stack is empty")

    // try sStack.push(10) // This will error out (Stack Overflow)

    try sStack.pop()
    print(sStack)
}
