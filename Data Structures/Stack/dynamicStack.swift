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

var dynamic = DynamicStack([1, 2, 3])

print(dynamic.peek() ?? "empty")
dynamic.push(4)

if let item = dynamic.pop() {
    print(item)
}
if let item = dynamic.pop() {
    print(item)
}

dynamic.removeAll()

if let item = dynamic.pop() {
    print(item)
} else {
    print("Stack is empty")
}
