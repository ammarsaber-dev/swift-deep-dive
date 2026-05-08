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

var dStack = DynamicStack([1, 2, 3, 4])

print(dStack)
dStack.push(5)
print(dStack)

let lastElement = dStack.peek()
print(lastElement ?? "Stack is empty")

dStack.pop()
print(dStack)
