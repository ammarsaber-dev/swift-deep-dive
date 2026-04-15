# Linear Search

#algorithm #searching #array #brute-force

Go through each element, one by one, until you find it.

![](https://turboyourcode.s3.amazonaws.com/media/Linear_Search.gif)

---
## How It Works
1. Start at the first element.
2. Is it the target? 
   * **Yes** → done, return the index.
   * **No** → move to the next element.
3. Repeat until you find it or reach the end.
4. Not found → return `nil`.

---
## Performance Complexity

| Case        | Time             | Space            | Notes                                                                                                             |
| :---------- | :--------------- | :--------------- | :---------------------------------------------------------------------------------------------------------------- |
| **Best**    | $\mathcal{O}(1)$ | $\mathcal{O}(1)$ | Target is the first element.                                                                                      |
| **Worst**   | $\mathcal{O}(n)$ | $\mathcal{O}(1)$ | Target is at the end or not in the array.                                                                         |
| **Average** | $\mathcal{O}(n)$ | $\mathcal{O}(1)$ | Found in the middle ($n/2$ steps).<br>We drop constants in Big O, so $\mathcal{O}(n/2)$ becomes $\mathcal{O}(n)$. |

*Space is always $\mathcal{O}(1)$ because it only uses a single index counter variable in memory.*

---
## Implementation

```swift
func linearSearch(in arr: [Int], for key: Int) -> Int? {
    for (idx, ele) in arr.enumerated() {
        if ele == key {
            return idx
        }
    }
    return nil
}

// ==================================================================

func swiftyLinearSearch(in arr: [Int], for key: Int) -> Int? {
    for (idx, ele) in arr.enumerated() where ele == key {
        return idx
    }
    return nil
}

let numbers = [1, 91, 72, 10, 5, 34]

if let index = linearSearch(in: numbers, for: 5) {
    print("Found the element at index \(index)")
} else {
    print("Element not found")
}

// output: Found the element at index 4
```
