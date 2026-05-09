struct StaticArray<T> {

    private var storage: [T?]
    private(set) var count: Int = 0
    let capacity: Int

    var isEmpty: Bool { count == 0 }
    var isFull: Bool { count == capacity }

    // Fills a fixed-size backing array with nil.
    // capacity = 3 → storage = [nil, nil, nil]
    init(capacity: Int) {
        self.capacity = capacity
        self.storage = [T?](repeating: nil, count: capacity)
    }

    // Direct index-based read/write — O(1).
    // arr[0] reads the first element; arr[1] = 5 overwrites the second.
    // Returns nil / silently ignores when index >= count.
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

    // Shifts elements right from the target index, then places the new value.
    // [10, 20, 30, nil, nil] → insert(15, at: 1) → [10, 15, 20, 30, nil, nil]
    // Returns false when full or index is invalid. O(n)
    @discardableResult
    mutating func insert(_ value: T, at index: Int) -> Bool {
        guard count < capacity else { return false }
        guard index >= 0 && index <= count else { return false }
        // Work backwards from the tail, sliding each element one slot right
        // to open a gap at the target index.
        for i in stride(from: count, to: index, by: -1) {
            storage[i] = storage[i - 1]
        }
        storage[index] = value
        count += 1
        return true
    }

    // Writes value at the first free slot (index == count) and increments count.
    // [10, 20, nil, nil] → append(30) → [10, 20, 30, nil]
    // Returns false when full. O(1)
    @discardableResult
    mutating func append(_ value: T) -> Bool {
        guard count < capacity else { return false }
        // count doubles as the index of the first free slot.
        storage[count] = value
        count += 1
        return true
    }

    // Shifts elements left to fill the removed slot, then nils out the tail.
    // [10, 20, 30, nil] → delete(at: 0) → [20, 30, nil, nil]
    // Returns false when index is invalid. O(n)
    @discardableResult
    mutating func delete(at index: Int) -> Bool {
        guard index >= 0 && index < count else { return false }
        // Work forwards from the target, sliding each element one slot left
        // to close the gap left by the removed element.
        for i in index..<(count - 1) {
            storage[i] = storage[i + 1]
        }
        count -= 1
        // Wipe the now-unused slot so we don't hold a stale reference.
        storage[count] = nil
        return true
    }

    // Decrements count, nils the vacated slot, returns the removed value.
    // [10, 20, 30, nil] → removeLast() → returns 30, storage = [10, 20, nil, nil]
    // Returns nil when empty. O(1)
    @discardableResult
    mutating func removeLast() -> T? {
        guard count > 0 else { return nil }
        count -= 1
        // count now points at the last active element (before it was the
        // first free slot). Grab it, then nil the slot.
        let removed = storage[count]
        storage[count] = nil
        return removed
    }
}

extension StaticArray: CustomStringConvertible {
    // Formats the active elements like a real array for printing.
    // storage = [10, 15, nil, nil], count = 2 → "[10, 15]"
    var description: String {
        let elements = storage[..<count]
            .compactMap { $0 }
            .map(String.init(describing:))
            .joined(separator: ", ")
        return "[\(elements)]"
    }
}

var arr = StaticArray<Int>(capacity: 5)

arr.append(10)
arr.append(20)
arr.append(30)
print(arr)

arr.insert(15, at: 1)
print(arr)

arr.delete(at: 0)
print(arr)

if let last = arr.removeLast() {
    print(last)
}
print(arr)

if let val = arr[0] {
    print(val)
}
print(arr.isEmpty)
print(arr.isFull)
