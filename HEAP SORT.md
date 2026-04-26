# Heap Sort Algorithm

## Idea

Heapsort is built on one key idea:

> Efficiently keep removing the **largest element**.

Instead of scanning the array every time (like selection sort), we:

1. Convert the array into a **max heap**
    
2. The largest element is always at the root
    
3. Swap it with the last element
    
4. Shrink the heap and repeat
    

This gives us a consistent **O(n log n)** sorting algorithm.

---

## Example

Start with this input:

![An unsorted input [8, 3, 2, 7, 9, 1, 4].](https://www.interviewcake.com/images/svgs/heapsort__unsorted_input_list_with_indexes.svg?bust=211)

Interpret it as a binary tree:

![Binary tree view](https://www.interviewcake.com/images/svgs/heapsort__input_list_as_binary_tree.svg?bust=211)

---

### Step 1: Heapify (Build Max Heap)

#### Goal

We want a **max heap**, where:

> Every parent ≥ its children

This guarantees the largest element is always at the root.

---

#### How we do it

We process the tree **bottom-up**:

- Leaves are already valid
    
- Fix each parent by pushing it **down** if needed
    
- This is called **bubble down**
    

---

#### Fix lower nodes first

![Bottom level](https://www.interviewcake.com/images/svgs/heapsort__binary_tree_with_highlighted_bottom_level.svg?bust=211)

Leaves need no changes.

Move up:

![Middle level](https://www.interviewcake.com/images/svgs/heapsort__binary_tree_with_highlighted_two_levels.svg?bust=211)

---

#### Fix node `3`

- Children: `7`, `9`
    
- Largest child = `9`
    
- Since `3 < 9`, swap
    

![Swap 3 with 9](https://www.interviewcake.com/images/svgs/heapsort__binary_tree_with_highlighted_nodes_3_9_7.svg?bust=211)

---

#### Fix node `2`

- Children: `1`, `4`
    
- Largest child = `4`
    
- Since `2 < 4`, swap
    

![Swap 2 with 4](https://www.interviewcake.com/images/svgs/heapsort__binary_tree_with_highlighted_nodes_2_1_4.svg?bust=211)

---

Now both subtrees are valid heaps:

![Sub-heaps](https://www.interviewcake.com/images/svgs/heapsort__binary_tree_with_highlighted_nodes_9_4_7_3_1_2.svg?bust=211)

---

#### Fix the root `8`

- Children: `9`, `4`
    
- Largest = `9`
    
- Swap since `8 < 9`
    

![Swap 8 with 9](https://www.interviewcake.com/images/svgs/heapsort__binary_tree_with_swapped_nodes_8_and_9.svg?bust=211)

Now check `8` again:

- Children: `7`, `3`
    
- `8` is already larger → stop
    


✅ Now we have a **valid max heap**

---

### Step 2: Start Sorting

Now we repeatedly remove the largest element and move it to the end.

Start with:

![Max heap](https://www.interviewcake.com/images/svgs/heapsort__binary_tree_with_max_root_element_9.svg?bust=211)

---

#### Remove the root (9)

![Remove 9](https://www.interviewcake.com/images/svgs/heapsort__binary_tree_with_deleted_max_node_9.svg?bust=211)

We can’t leave a gap, so:

- Move the **last element (2)** to the root
    

![Move 2](https://www.interviewcake.com/images/svgs/heapsort__binary_tree_with_moving_node_2_to_the_root.svg?bust=211)

---

#### Restore the heap

Now `2` is too small, so we **bubble it down**:

- Compare with children (`8`, `4`)
    
- Swap with the larger (`8`)
    
- Continue until valid
    

![Bubble down](https://www.interviewcake.com/images/svgs/heapsort__binary_tree_swapping_node_7_and_2.svg?bust=211)

---

#### Place 9 at the end

![Place 9](https://www.interviewcake.com/images/svgs/heapsort__binary_tree_with_sorted_node_9.svg?bust=211)

Now:

- Left → heap
    
- Right → sorted
    

![Split](https://www.interviewcake.com/images/svgs/heapsort__binary_tree_with_sorted_node_9_and_unsorted_nodes.svg?bust=211)

---

#### Repeat

Remove 8:

![Remove 8](https://www.interviewcake.com/images/svgs/heapsort__binary_tree_with_removed_node_8.svg?bust=211)

Fix heap:

![Bubble 1](https://www.interviewcake.com/images/svgs/heapsort__binary_tree_with_swapping_node_1_down.svg?bust=211)

Place it:

![Place 8](https://www.interviewcake.com/images/svgs/heapsort__binary_tree_with_sorted_nodes_8_and_9.svg?bust=211)

---

Remove 7:

![Remove 7](https://www.interviewcake.com/images/svgs/heapsort__binary_tree_with_deleted_max_node_7.svg?bust=211)

Fix:

![Fix](https://www.interviewcake.com/images/svgs/heapsort__binary_tree_with_sort_max_node_7.svg?bust=211)

---

Remove 4:

![Remove 4](https://www.interviewcake.com/images/svgs/heapsort__binary_tree_with_deleted_max_node_4.svg?bust=211)

Fix:

![Fix](https://www.interviewcake.com/images/svgs/heapsort__binary_tree_with_sorted_max_node_4.svg?bust=211)


Repeat until fully sorted.

---

## Algorithm

High-level steps:

1. **Heapify the array** (build max heap)
    
2. Repeat until heap size = 0:
    
    - Swap root with last element
        
    - Reduce heap size
        
    - Bubble down the root
        

Core operations:

- **heapify**
    
- **bubbleDown**
    
- **removeMax**
    

---

## Time Complexity

|Case|Complexity|
|---|---|
|Worst|O(n log n)|
|Average|O(n log n)|
|Best|O(n)|

- Heapify: **O(n)**
    
- Each removal: **O(log n)**
    
- Total: **O(n log n)**
    

Best case occurs when no bubbling is needed (e.g., all elements equal).

---

## Space Complexity

- **O(1)** (in-place)
    
- No extra memory required
    

---

## When to Use Heapsort

Use heapsort when:

- You need **guaranteed O(n log n)** performance
    
- Memory is limited → **in-place sorting**
    
- You want predictable behavior (no worst-case surprises)
    

Avoid it when:

- You want maximum real-world speed → quicksort is usually faster
    
- You need stability → heapsort is **not stable**
    