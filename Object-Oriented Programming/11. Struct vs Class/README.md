# Struct vs Class

Throughout these notes we've been using classes for everything. but Swift has another way to create custom types: structs. they look similar on the surface but they behave very differently under the hood.

## What is the Difference?

The core difference is one word: **copying**.

When you copy a class, you copy the **reference**. both variables point to the same object in memory, so a change through one affects the other.

When you copy a struct, you copy the **value**. each variable gets its own independent copy, so a change to one has no effect on the other.

Think of it like this. a class is like a shared Google Doc, everyone who has the link is looking at the same document, if one person edits it everyone sees the change. a struct is like a PDF you download, you get your own copy, you can edit it all you want and nobody else is affected.

## Reference Type vs Value Type

Let's see the difference in code.

**Class (reference type):**

```swift
class Car {
    var color: String
    init(color: String) { self.color = color }
}

let car1 = Car(color: "Red")
let car2 = car1 // car2 points to the same object as car1

car2.color = "Blue"
print(car1.color) // "Blue" — car1 was affected!
print(car2.color) // "Blue"
```

**Struct (value type):**

```swift
struct Car {
    var color: String
}

var car1 = Car(color: "Red")
var car2 = car1 // car2 gets its own independent copy

car2.color = "Blue"
print(car1.color) // "Red" — car1 was not affected
print(car2.color) // "Blue"
```

Same code, completely different behavior. here's what's happening in memory:

```
Class (reference type):
car1 ──► [ color: "Blue" ]  ← both point to the same object
car2 ──►       ↑

Struct (value type):
car1 ──► [ color: "Red" ]   ← each has its own independent copy
car2 ──► [ color: "Blue" ]
```

this is the most important thing to understand about structs and classes in Swift.

## Mutability

`let` and `var` behave differently with classes and structs.

With a **class**, `let` only prevents the reference from pointing to a different object. the object itself can still be mutated:

```swift
let car = Car(color: "Red") // class
car.color = "Blue" // works fine, the object is mutable
```

With a **struct**, `let` makes the entire value immutable. you can't change any property:

```swift
let car = Car(color: "Red") // struct
car.color = "Blue" // error: cannot assign to property: 'car' is a 'let' constant
```

And if you want to change a property inside a struct method, you have to mark the method as `mutating`:

```swift
struct Car {
    var color: String

    mutating func repaint(to newColor: String) {
        color = newColor
    }
}

var car = Car(color: "Red")
car.repaint(to: "Blue")
print(car.color) // "Blue"
```

## Inheritance

Structs can't inherit from other structs. classes can inherit from other classes.

```swift
class Vehicle {
    var speed: Double = 0.0
}

class Car: Vehicle { } // works fine

struct Vehicle {
    var speed: Double = 0.0
}

struct Car: Vehicle { } // error: inheritance from non-protocol type 'Vehicle'
```

If you need inheritance, you need a class. if you don't, a struct is usually the better choice.

## When to Use Which?

A simple rule Apple follows in Swift: **prefer structs by default, use classes when you need reference semantics.**

Use a **struct** when:

- The data is simple and self-contained, like a coordinate, a color, or a user profile.
- You want each copy to be independent.
- You don't need inheritance.

Use a **class** when:

- You need to share state across multiple parts of your app.
- You need inheritance.
- You're working with UIKit, since most UIKit components like `UIViewController` and `UIView` are classes.

In SwiftUI, you'll use structs for views and classes for shared state (`ObservableObject`). in UIKit, almost everything is a class. knowing which to reach for comes with experience, but defaulting to structs is always a safe start.

## Key Takeaways

- Classes are reference types, structs are value types.
- Copying a class copies the reference, copying a struct copies the value.
- `let` on a class only locks the reference, `let` on a struct locks the entire value.
- Structs can't inherit, classes can.
- Prefer structs by default, use classes when you need reference semantics or inheritance.

## Try It Yourself

**Review Questions**

1. What is the difference between a reference type and a value type?
2. Why do struct methods that modify properties need the `mutating` keyword?

**Challenge** Create a `Point` struct with `x: Double` and `y: Double`. add a `mutating func move(x:y:)` method that adds the given values to the current position. create two points, assign one to the other, move the second one, and print both. what do you expect to see and why?

> [!faq]- Answers (click to reveal)
> 
> **Review Questions**
> 
> 1. A reference type shares the same object in memory when copied, so changes through one variable affect all others pointing to the same object. a value type creates an independent copy when assigned, so changes to one have no effect on the other.
> 2. Structs are value types and are immutable by default. the `mutating` keyword tells Swift that this method is allowed to change the struct's properties. without it, Swift treats the struct as immutable inside the method and won't compile.
> 
> **Challenge Solution**
> 
> ```swift
> struct Point {
>     var x: Double
>     var y: Double
> 
>     mutating func move(x deltaX: Double, y deltaY: Double) {
>         x += deltaX
>         y += deltaY
>     }
> }
> 
> var point1 = Point(x: 0, y: 0)
> var point2 = point1 // independent copy
> 
> point2.move(x: 5, y: 10)
> 
> print(point1.x, point1.y) // 0.0 0.0 — not affected
> print(point2.x, point2.y) // 5.0 10.0
> ```
> 
> `point2` got its own copy when assigned, so moving it had no effect on `point1`.