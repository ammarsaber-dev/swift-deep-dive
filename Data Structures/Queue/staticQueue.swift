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

var fixedQueue = StaticQueue<Int>(capacity: 3)

fixedQueue.enqueue(1)
fixedQueue.enqueue(2)
fixedQueue.enqueue(3)

if !fixedQueue.enqueue(4) {
    print("Queue is full!")
}

if let item = fixedQueue.peek() {
    print(item)
}

if let item = fixedQueue.dequeue() {
    print(item)
}
if let item = fixedQueue.dequeue() {
    print(item)
}

fixedQueue.removeAll()

if let item = fixedQueue.dequeue() {
    print(item)
} else {
    print("Queue is empty")
}
