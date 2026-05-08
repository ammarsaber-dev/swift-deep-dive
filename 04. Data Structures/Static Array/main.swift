import Foundation

struct StaticArray<T> {
    private var storage: [T?]
    private(set) var count: Int = 0
    let capacity: Int

    var isEmpty: Bool {
        count == 0
    }

    var isFull: Bool {
        count == capacity
    }

    init(capacity: Int) {
        self.capacity = capacity
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

    mutating func insert(_ value: T, at index: Int) {
        guard count < capacity else { return }
        guard index >= 0 && index <= count else { return }

        for i in stride(from: count, to: index, by: -1) {
            storage[i] = storage[i - 1]
        }

        storage[index] = value
        count += 1
    }

    mutating func append(_ value: T) {
        guard count < capacity else { return }

        storage[count] = value
        count += 1
    }

    mutating func delete(at index: Int) {
        guard index >= 0 && index < count else { return }

        for i in index..<(count - 1) {
            storage[i] = storage[i + 1]
        }

        count -= 1
        storage[count] = nil
    }

    @discardableResult
    mutating func removeLast() -> T? {
        guard count > 0 else { return nil }

        count -= 1

        let removed = storage[count]
        storage[count] = nil

        return removed
    }

    func search(where predicate: (T) -> Bool) -> Int? {
        for i in 0..<count {
            if let el = storage[i], predicate(el) { return i }
        }

        return nil
    }
}

extension StaticArray: CustomStringConvertible {
    var description: String {
        let elements = storage[..<count]
            .compactMap { $0 }
            .map(String.init(describing:))
            .joined(separator: ", ")

        return "[\(elements)]"
    }
}

var arr = StaticArray<Int>(capacity: 5)
print(arr, arr.count)

arr.append(10)
arr.append(20)
arr.append(30)
arr.append(40)
arr.append(50)
print(arr, arr.count)

arr.delete(at: 0)
print(arr, arr.count)

if let index = arr.search(where: { $0 == 20 }) {
    print("found 20 at index \(index)")
}

arr.insert(0, at: 0)
print(arr, arr.count)

if let index = arr.search(where: { $0 == 20 }) {
    print("found 20 at index \(index)")
}

arr.removeLast()

print(arr, arr.count)
print(arr.isFull ? "The Array is full" : "The Array is NOT full")
