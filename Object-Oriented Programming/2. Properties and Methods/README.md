# Properties and Methods

In the [previous topic](Object-Oriented%20Programming/1.%20Class,%20Object%20and%20Constructor/README.md) we covered Class, Object and Constructor. Now let's talk about Properties and Methods.

## What are Properties?

Properties are the data that an object holds, they describe what an object is. In the Car example, a car can have properties like:

- Brand
- Model
- Manufacture Year
- Color
- Speed

## What are Methods?

Methods are the actions an object can perform, they describe what an object can do. In the Car example, a car can:

- Start Engine
- Brake
- Stop Engine
- Refuel

## Code

Let's implement that example in Swift.

```swift
// Car class with the following:
// Properties: brand, color, speed, manufactureYear
// Methods: startEngine(), brake(), stopEngine(), refuel()

class Car {
    // Properties
    let brand: String
    let manufactureYear: Int
    var color: String
    var speed: Double

    // Initializer / Constructor
    init(brand: String, manufactureYear: Int, color: String, speed: Double) {
        // self refers to the current object, used to distinguish between the property and the parameter.
        self.brand = brand
        self.manufactureYear = manufactureYear
        self.color = color
        self.speed = speed
    }

    // Methods
    func startEngine() {
        print("Engine started")
    }

    func brake() {
        if speed > 0 {
            speed -= 10
            print("Braking, speed is now \(speed)")
        } else {
            print("Car is already stopped")
        }
    }

    func stopEngine() {
        speed = 0.0
        print("Engine stopped, speed is now \(speed)")
    }

    func refuel() {
        print("Refueling")
    }
}
```

Notice that the methods interact with the `speed` property. `brake()` reduces it and `stopEngine()` resets it back to `0.0`. This is how properties and methods work together inside a class.

Now let's create some objects and use them:

```swift
let car1 = Car(brand: "Toyota", manufactureYear: 2020, color: "Red", speed: 0.0)

// accessing properties
print(car1.brand)  // "Toyota"
print(car1.color)  // "Red"

// calling methods
car1.startEngine() // "Engine started"
car1.brake()       // "Braking, speed is now 20.0"
car1.stopEngine()  // "Engine stopped, speed is now 0.0"

let car2 = Car(brand: "BMW", manufactureYear: 2023, color: "Black", speed: 0.0)
car2.startEngine()
car2.brake()
car2.stopEngine()
```

### A note on Initializers

In Swift, a class doesn't get a default initializer, so we have to create our own. If we don't, we get this error:

```
error: 'Car' cannot be constructed because it has no accessible initializers.
```

And if we create an empty initializer without setting the properties:

```
error: return from initializer without initializing all stored properties
```

The fix is to either set default values for the properties, or pass them through the initializer like we did above.


## Key Takeaways

- Properties store data; methods define behavior.
- `self` distinguishes between parameters and properties with the same name.
- All stored properties must have a value by the time `init` finishes.


## Try It Yourself

**Review Questions**
1. What keyword does Swift use in an initializer to distinguish between a property and a parameter with the same name?
2. Why must all stored properties have a value by the time `init` finishes?

**Challenge**
Create a `Book` class with `title: String`, `author: String`, and `pagesCount: Int` properties and an `init` that takes all three. Then add `open()` and `close()` methods that print a message. Create a book object and call both methods.

> [!faq]- Answers (click to reveal)
>
> **Review Questions**
> 1. `self` — it distinguishes the property (`self.name`) from the parameter (`name`). Without it, the parameter name shadows the property and Swift can't tell which one you mean.
> 2. Without initialization, reading a property would access uninitialized memory — the value is undefined and could be anything. Swift prevents this entirely by refusing to compile code that doesn't initialize every stored property by the time `init` finishes.
>
> **Challenge Solution**
> ```swift
> class Book {
>     var title: String
>     var author: String
>     var pagesCount: Int
>
>     init(title: String, author: String, pagesCount: Int) {
>         self.title = title
>         self.author = author
>         self.pagesCount = pagesCount
>     }
>
>     func open() {
>         print("Opened the book \(title)")
>     }
>
>     func close() {
>         print("Closed the book \(title)")
>     }
> }
>
> let book = Book(title: "1984", author: "George Orwell", pagesCount: 328)
> book.open()
> book.close()
> ```