struct DynamicArray<T> {

    private var storage: [T?]
    private(set) var count: Int = 0
    private(set) var capacity: Int

    var isEmpty: Bool { count == 0 }
    var isFull: Bool { count == capacity }

    init() {
        capacity = 4
        storage = [T?](repeating: nil, count: capacity)
    }

    subscript(index: Int) -> T? {
        get {
            guard index >= 0 && index < count else { return nil }
            return storage[index]
        }
        set {
            guard index >= 0 && index < count else { return }
            storage[index] = newValue
        }
    }

    mutating func append(_ value: T) {
        if count == capacity { resize() }
        storage[count] = value
        count += 1
    }

    @discardableResult
    mutating func insert(_ value: T, at index: Int) -> Bool {
        guard index >= 0 && index <= count else { return false }
        if count == capacity {
            resize()
        }
        for i in stride(from: count, to: index, by: -1) {
            storage[i] = storage[i - 1]
        }
        storage[index] = value
        count += 1
        return true
    }

    @discardableResult
    mutating func delete(at index: Int) -> Bool {
        guard index >= 0 && index < count else { return false }
        for i in index..<(count - 1) {
            storage[i] = storage[i + 1]
        }
        count -= 1
        storage[count] = nil
        return true
    }

    @discardableResult
    mutating func removeLast() -> T? {
        guard count > 0 else { return nil }
        count -= 1
        let removed = storage[count]
        storage[count] = nil
        return removed
    }

    mutating func removeAll() {
        storage = [T?](repeating: nil, count: capacity)
        count = 0
    }

    // Doubles capacity by allocating a new buffer and copying elements over.
    // This occasional O(n) copy makes append O(1) amortized.
    private mutating func resize() {
        let newCapacity = capacity * 2
        var newStorage = [T?](repeating: nil, count: newCapacity)
        for i in 0..<count {
            newStorage[i] = storage[i]
        }
        storage = newStorage
        capacity = newCapacity
    }
}

extension DynamicArray: CustomStringConvertible {
    var description: String {
        let elements = storage[..<count]
            .compactMap { $0 }
            .map(String.init(describing:))
            .joined(separator: ", ")
        return "[\(elements)]"
    }
}

var dynamic = DynamicArray<Int>()

dynamic.append(10)
dynamic.append(20)
dynamic.append(30)
print(dynamic)

dynamic.insert(15, at: 1)
print(dynamic)

dynamic.delete(at: 0)
print(dynamic)

if let last = dynamic.removeLast() {
    print(last)
}
print(dynamic)

if let val = dynamic[0] {
    print(val)
}
print(dynamic.isEmpty)
print(dynamic.capacity)
