# Abstraction

Abstraction is the last of the four pillars of OOP, the idea is simple, you hide how something works and only show what it does.

## What is Abstraction?

Think of a payment system, when you tap your card to pay you don't know what happens internally, bank checks, fraud detection, currency conversion, all of that is hidden. You just know that tapping the card completes the payment.

That's exactly what abstraction does in code, you define what an object can do without showing how it does it. but why does this matter?

## Why Abstraction?

Without abstraction the caller has to know everything about the internals:

```swift
// bad: the caller has to know too much
let car = Car()
car.injectFuel()
car.fireSparkPlugs()
car.rotateCrankshaft()
car.engageGears()
```

With abstraction the caller only knows what they need:

```swift
// good: simple and clean
let car = Car()
car.start()
```

`start()` hides all the internal steps, the caller doesn't need to know how the engine starts, just that it does. this makes your code:

- Easier to read, other developers only see what matters.
- Easier to maintain, you can change how something works internally without touching the code that uses it.
- More reusable, you define a common interface once and any type can use it.
- Easier to test, you can test each piece on its own.

Now you might be thinking, isn't this the same as Encapsulation? not quite.

## Abstraction vs Encapsulation

Both hide things, but they hide different things.

- **Encapsulation** hides the data inside a class and controls how it's accessed.
- **Abstraction** hides the implementation details and exposes a simple interface.

A simple way to remember:

- Encapsulation: _"you can't touch this directly, use the method."_
- Abstraction: _"you don't need to know how this works, just call it."_

So how do you actually implement abstraction in Swift?

## Abstract Methods (the Swift way)

In some languages like Java or C++, you can mark a method as `abstract` which forces every subclass to provide its own version. Swift doesn't have this keyword.

The Swift way is to use `fatalError()` in the base class method, it crashes the app with a clear message if a subclass forgets to override it:

```swift
class Vehicle {
    func makeNoise() -> String {
        fatalError("makeNoise() must be overridden by subclass")
    }
}

class Bicycle: Vehicle {
    // forgot to override makeNoise()
}

let bike = Bicycle()
bike.makeNoise() // crash: makeNoise() must be overridden by subclass
```

The crash makes it clear what went wrong and where to fix it. but it only catches the mistake at runtime, not before. that's the limitation, and Swift has a better solution.

## Base Class vs Protocol

The better solution is **protocols**. here's the same example using both approaches:

**Base class with `fatalError()`:**

```swift
class Vehicle {
    func makeNoise() -> String {
        fatalError("makeNoise() must be overridden by subclass")
    }
}

class Car: Vehicle {
    override func makeNoise() -> String { return "Vroom!" }
}
```

**Protocol:**

```swift
protocol Vehicle {
    func makeNoise() -> String
}

struct Car: Vehicle {
    func makeNoise() -> String { return "Vroom!" }
}
```

||Base Class + `fatalError()`|Protocol|
|---|---|---|
|Caught when?|Runtime (app crashes)|Compile time (won't build)|
|Works with structs?|No|Yes|
|Multiple conformance?|No (one superclass only)|Yes (multiple protocols)|
|Swift way?|Workaround|Yes|

Protocols are the real Swift way of abstraction, cleaner, safer, and more flexible. we will cover them in depth in the [Protocols](#) topic. you'll also see them everywhere in iOS development, `Codable`, `Equatable`, and `UITableViewDataSource` are all protocols.

## Key Takeaways

- Abstraction hides how something works and exposes what it does.
- Encapsulation hides data, abstraction hides implementation details.
- `fatalError()` enforces overrides at runtime, protocols enforce them at compile time.
- Protocols are the real Swift way of abstraction, we will cover them soon.

## Try It Yourself

**Review Questions**

1. What is the difference between abstraction and encapsulation?
2. What is the limitation of using `fatalError()` compared to protocols?

**Challenge** Create a `Shape` base class with an abstract method `area() -> Double` that uses `fatalError()`. Then create `Circle` and `Rectangle` subclasses that override `area()`. Store them in a `[Shape]` array and print the area of each one.

> [!faq]- Answers (click to reveal)
> 
> **Review Questions**
> 
> 1. Encapsulation hides data and controls access to it. Abstraction hides implementation details and exposes a simple interface. Encapsulation protects state, abstraction simplifies interaction.
> 2. `fatalError()` only crashes at runtime when the code actually runs. Protocols catch the mistake at compile time before the app even runs.
> 
> **Challenge Solution**
> 
> ```swift
> class Shape {
>     func area() -> Double {
>         fatalError("area() must be overridden by subclass")
>     }
> }
> 
> class Circle: Shape {
>     var radius: Double
>     init(radius: Double) { self.radius = radius }
>     override func area() -> Double {
>         return Double.pi * radius * radius
>     }
> }
> 
> class Rectangle: Shape {
>     var width: Double
>     var height: Double
>     init(width: Double, height: Double) {
>         self.width = width
>         self.height = height
>     }
>     override func area() -> Double {
>         return width * height
>     }
> }
> 
> let shapes: [Shape] = [Circle(radius: 5), Rectangle(width: 4, height: 6)]
> for shape in shapes {
>     print(shape.area())
> }
> // 78.53981633974483
> // 24.0
> ```