func linearSearch(in arr: [Int], for key: Int) -> Int? {
    for (idx, ele) in arr.enumerated() {
        if ele == key {
            return idx
        }
    }

    return nil
}

// ==================================================================

func linearSearch2(in arr: [Int], for key: Int) -> Int? {
    for (idx, ele) in arr.enumerated() where ele == key {
        return idx
    }

    return nil
}

let numbers = [1, 91, 72, 10, 5, 34]

if let index = linearSearch2(in: numbers, for: 5) {
    print("Found the element at index \(index)")
} else {
    print("Element not found")
}
