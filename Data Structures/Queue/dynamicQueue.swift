struct DynamicQueue<T> {
    private var storage: [T] = []
    // Normally, removing from the front means shifting every element left — O(n).
    // Instead, we just slide this marker forward. Everything before head is
    // treated as "removed" even though it's still sitting in memory.
    private var head: Int = 0

    init() {}
    // First element becomes the front of the queue.
    init(_ elements: [T]) {
        storage = elements
    }

    var isEmpty: Bool {
        head >= storage.count
    }

    var count: Int {
        storage.count - head
    }

    mutating func enqueue(_ item: T) {
        storage.append(item)
    }

    // Skips the expensive shift by reading storage[head] and advancing the
    // head marker — O(1).
    //
    // The trade-off: consumed elements pile up before head, wasting memory.
    // Once head passes the halfway point, we finally do a bulk cleanup with
    // removeFirst(head), reclaiming all that space at once.
    // This keeps dequeue fast (amortized O(1)) while keeping memory in check.
    // Returns nil when the queue is empty.
    @discardableResult
    mutating func dequeue() -> T? {
        guard !isEmpty else { return nil }

        let item = storage[head]
        head += 1

        // Say we enqueued 10 items then dequeued 6:
        //   storage = [a, b, c, d, e, f, g, h, i, j], head = 6
        // Six dead elements (a-f) sit before head — over half the array.
        // removeFirst(head) chops them off → [g, h, i, j], head resets to 0.
        if head > storage.count / 2 {
            storage.removeFirst(head)
            head = 0
        }

        return item
    }

    func peek() -> T? {
        guard !isEmpty else { return nil }
        return storage[head]
    }

    mutating func removeAll() {
        storage.removeAll()
        head = 0
    }
}

var dynamic = DynamicQueue([1, 2, 3])

dynamic.enqueue(4)

if let item = dynamic.dequeue() {
    print(item)
}
if let item = dynamic.dequeue() {
    print(item)
}

if let item = dynamic.peek() {
    print(item)
}

dynamic.removeAll()

if let item = dynamic.dequeue() {
    print(item)
} else {
    print("Queue is empty")
}
