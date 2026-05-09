import Foundation

struct StaticArray<T> {

    // Internal storage using [T?] so unused slots can be nil.
    // capacity = 5 → [10, 20, nil, nil, nil]
    private var storage: [T?]

    // Number of active elements.
    // [10, 20, nil, nil, nil] → count = 2
    private(set) var count: Int = 0

    // Fixed maximum size — never changes after init.
    let capacity: Int

    // O(1)
    var isEmpty: Bool { count == 0 }

    // O(1)
    var isFull: Bool { count == capacity }

    init(capacity: Int) {
        self.capacity = capacity
        // capacity = 5 → [nil, nil, nil, nil, nil]
        self.storage = [T?](repeating: nil, count: capacity)
    }

    // arr[0], arr[2] = 99 — O(1)
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

    // Inserts while preserving order — O(n)
    // [10, 20, 30, nil, nil] → insert(15, at: 1)
    // Shift right: [10, 20, 20, 30, nil]
    // Place value: [10, 15, 20, 30, nil]
    mutating func insert(_ value: T, at index: Int) {
        guard count < capacity else { return }
        guard index >= 0 && index <= count else { return }
        for i in stride(from: count, to: index, by: -1) {
            storage[i] = storage[i - 1]
        }
        storage[index] = value
        count += 1
    }

    // Adds element at the end — O(1)
    // [10, 20, nil, nil] → append(30) → [10, 20, 30, nil]
    mutating func append(_ value: T) {
        guard count < capacity else { return }
        storage[count] = value
        count += 1
    }

    // Deletes while preserving order — O(n)
    // [10, 20, 30, 40, nil] → delete(at: 1)
    // Shift left: [10, 30, 40, 40, nil]
    // Cleanup:    [10, 30, 40, nil, nil]
    mutating func delete(at index: Int) {
        guard index >= 0 && index < count else { return }
        for i in index..<(count - 1) {
            storage[i] = storage[i + 1]
        }
        count -= 1
        storage[count] = nil
    }

    // Removes the final element — O(1)
    // [10, 20, 30, nil] → removeLast() → [10, 20, nil, nil]
    @discardableResult
    mutating func removeLast() -> T? {
        guard count > 0 else { return nil }
        count -= 1
        let removed = storage[count]
        storage[count] = nil
        return removed
    }

}

// print(arr) → [10, 20, 30]
extension StaticArray: CustomStringConvertible {
    var description: String {
        let elements = storage[..<count]
            .compactMap { $0 }
            .map(String.init(describing:))
            .joined(separator: ", ")
        return "[\(elements)]"
    }
}

// Usage
var arr = StaticArray<Int>(capacity: 5)

arr.append(10)
arr.append(20)
arr.append(30)
print(arr)  // [10, 20, 30]

arr.insert(15, at: 1)
print(arr)  // [10, 15, 20, 30]

arr.delete(at: 0)
print(arr)  // [15, 20, 30]

print(arr.removeLast() ?? "empty")  // 30
print(arr)  // [15, 20]

print(arr[0] ?? "empty")  // 15
print(arr.isEmpty)  // false
print(arr.isFull)  // false
