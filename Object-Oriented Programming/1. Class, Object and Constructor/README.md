# Class, Object and Constructor

## What is a Class?

A class is a blueprint from which objects are created.

Think of a Car Manufacturer, when the company wants to create a new car it first goes for a design. The design is a blueprint for the production team to then produce the real car you are driving.

## What is an Object?

An object is an instance of a class, it's the real thing created from the blueprint.

The class in this case is the design, and the object is the final product you perform actions on like drive, stop and so on. The Manufacturer has the design (class) so it can create as many cars (objects) as it wants.

## What is a Constructor?

So we have the blueprint (class) and the final product (object), but what is a constructor?

A constructor is a special function that runs when an object is created. The production team is a good way to think about it, they are responsible for taking the design and producing the real car.

Does that mean it can have multiple constructors? Yeah, the company can have more than one team to create different styles of that design, different cars with different properties and functions, but all of them still follow the same blueprint.

## Coding

Applying what we explained with code. We will create a class named `Car` in Swift as following:

```swift
class Car {
    // properties

    // methods

    // constructor (initializer)
    init() {}
}
```

And for creating an object from the class we can do this:

```swift
let carA: Car = Car() // constant, carA will always point to this object
var carB: Car = Car() // variable, carB can be changed to point to a different object

carB = carA // works fine, carB now points to carA
carA = carB // error, carA is a constant
```

In the next part we will cover properties and methods and how to use them inside a class.

---

## Key Takeaways

- A class is a blueprint; an object is an instance created from that blueprint.
- The constructor (`init`) runs when an object is created.
- `let` fixes the reference — it can't point elsewhere. `var` allows reassignment.

---

## Try It Yourself

**Review Questions**
1. What's the difference between a class and an object?
2. In `let carA = Car()` and `var carB = Car()`, what happens when you try `carA = carB` vs `carB = carA`?

**Challenge**
Create a `Game` class with an empty `init() {}`. Then create two objects: one with `let` and one with `var`. Try assigning the `let` reference to the `var` one, and the `var` reference to the `let` one. What works and what doesn't? Why?

> [!faq]- Answers (click to reveal)
>
> **Review Questions**
> 1. A class is a blueprint that defines the structure and behavior of an object. An object is a concrete instance created from that blueprint, allocated in memory with its own copy of the stored properties.
> 2. `carA = carB` fails because `carA` is declared with `let`, which makes it a constant reference — it can only point to the object it was initialized with, for its entire lifetime. The compiler enforces this, so the code won't even build. `carB = carA` works because `carB` is declared with `var`, a variable reference that can be reassigned to point to any other object of the same type.
>
> **Challenge Solution**
> ```swift
> class Game {
>     init() {}
> }
>
> let game1 = Game()
> var game2 = Game()
>
> game2 = game1 // works — game2 is var, its reference can change whenever needed
> game1 = game2 // error: cannot assign to value: 'game1' is a 'let' constant
> ```
>
> `game1 = game2` fails because `game1` is `let`, its reference is locked to the first object. 
> `game2 = game1` succeeds because `game2` is `var`, it can point to any `Game` object at any time.