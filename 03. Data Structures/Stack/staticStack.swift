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

var fixedStack = StaticStack<Int>(capacity: 3)

fixedStack.push(1)
fixedStack.push(2)
fixedStack.push(3)

if !fixedStack.push(4) {
    print("Stack is full")
}

print(fixedStack.peek() ?? "empty")

if let item = fixedStack.pop() {
    print(item)
}
if let item = fixedStack.pop() {
    print(item)
}

fixedStack.removeAll()

if let item = fixedStack.pop() {
    print(item)
} else {
    print("Stack is empty")
}
