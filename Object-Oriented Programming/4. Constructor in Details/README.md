# Constructor in Details

In a [previous topic](Object-Oriented%20Programming/1.%20Class,%20Object%20and%20Constructor/README.md) we briefly touched on constructors. Now let's go deeper and cover everything about them.

## 1. Default Initializer

When all properties have default values, Swift gives you a free empty `init()` automatically:

```swift
class Car {
    var brand: String = "Unknown"
    var color: String = "White"
    var speed: Double = 0.0

    // no init needed, Swift generates one for us
}

let car1 = Car()
print(car1.brand) // "Unknown"
```

But if any property doesn't have a default value, Swift won't generate one and you have to write your own.

## 2. Custom Initializer

Instead of relying on default values, you can pass values when creating the object:

```swift
class Car {
    var brand: String
    var color: String
    var speed: Double

    init(brand: String, color: String, speed: Double) {
        // self refers to the current object, used to distinguish between the property and the parameter.
        self.brand = brand
        self.color = color
        self.speed = speed
    }
}

let car1 = Car(brand: "Toyota", color: "Red", speed: 0.0)
print(car1.brand) // "Toyota"
```

## 3. Multiple Initializers

A class can have more than one `init`, each with different parameters, Swift picks the right one based on what you pass:

```swift
class Car {
    var brand: String
    var color: String
    var speed: Double

    init(brand: String, color: String, speed: Double) {
        self.brand = brand
        self.color = color
        self.speed = speed
    }

    init(brand: String) {
        self.brand = brand
        self.color = "White"
        self.speed = 0.0
    }
}

let car1 = Car(brand: "Toyota", color: "Red", speed: 0.0)
let car2 = Car(brand: "BMW") // color and speed get default values
```

## 4. Default Parameter Values

Instead of writing multiple initializers you can give parameters default values in a single `init`:

```swift
class Car {
    var brand: String
    var color: String
    var speed: Double

    init(brand: String, color: String = "White", speed: Double = 0.0) {
        self.brand = brand
        self.color = color
        self.speed = speed
    }
}

let car1 = Car(brand: "Toyota") // color = "White", speed = 0.0
let car2 = Car(brand: "BMW", color: "Black") // speed = 0.0
let car3 = Car(brand: "Mercedes", color: "Red", speed: 120.0)
```

Cleaner than writing multiple initializers for the same thing.

## 5. Initializer Delegation

One `init` can call another `init` using `self.init()`, this avoids repeating the same setup code:

```swift
class Car {
    var brand: String
    var color: String
    var speed: Double

    init(brand: String, color: String, speed: Double) {
        self.brand = brand
        self.color = color
        self.speed = speed
    }

    init(brand: String) {
        self.init(brand: brand, color: "White", speed: 0.0)
    }
}

let car1 = Car(brand: "Toyota") // delegates to the first init
```

## 6. Failable Initializer

What if the values you pass are not valid? a failable initializer `init?` can return `nil` in that case:

```swift
class Car {
    var brand: String
    var speed: Double

    init?(brand: String, speed: Double) {
        if speed < 0 {
            return nil // speed can't be negative
        }
        self.brand = brand
        self.speed = speed
    }
}

let car1 = Car(brand: "Toyota", speed: 0.0)  // Optional(Car)
let car2 = Car(brand: "BMW", speed: -10.0)   // nil
```

Since the result can be `nil`, the object comes back as an Optional and you have to unwrap it before using it:

```swift
if let car = car1 {
    print(car.brand) // "Toyota"
} else {
    print("Failed to create car")
}
```

## 7. Required Initializer

A `required init` forces every subclass to implement that same initializer, if a subclass doesn't, Swift will error out:

```swift
class Car {
    var brand: String

    required init(brand: String) {
        self.brand = brand
    }
}

class ElectricCar: Car {
    var batteryLevel: Double

    required init(brand: String) {
        self.batteryLevel = 100.0
        super.init(brand: brand) // calls the parent's init (covered in Inheritance)
    }
}
```

We will cover subclasses and `super` in the [Inheritance](Object-Oriented%20Programming/6.%20Inheritance/README.md) topic.

## 8. Convenience Initializer

A convenience initializer is a shortcut initializer that must call the main `init` using `self.init()`:

```swift
class Car {
    var brand: String
    var color: String
    var speed: Double

    init(brand: String, color: String, speed: Double) {
        self.brand = brand
        self.color = color
        self.speed = speed
    }

    convenience init(brand: String) {
        self.init(brand: brand, color: "White", speed: 0.0)
    }
}

let car1 = Car(brand: "Toyota") // uses the convenience initializer
let car2 = Car(brand: "BMW", color: "Black", speed: 0.0) // uses the main initializer
```

Looks similar to initializer delegation, the difference is the `convenience` keyword which tells Swift this is a helper initializer, not the main one.


## Key Takeaways

- A default initializer is provided only when all properties have default values.
- A failable initializer `init?` returns `nil` if conditions aren't met.
- `convenience init` must delegate to the designated `init` via `self.init()`.
- `required init` forces every subclass to implement the same initializer.


## Try It Yourself

**Review Questions**
1. What's the difference between a failable initializer `init?` and a regular initializer?
2. When would you use a `convenience init` instead of default parameter values?

**Challenge**
Write a failable `init?` for a `Product` class that returns `nil` if `price` is negative. Also add a `convenience init` that defaults `name` to "Untitled" and `price` to 0.0, delegating to the main initializer.

> [!faq]- Answers (click to reveal)
>
> **Review Questions**
> 1. A failable initializer `init?` can return `nil` if initialization fails. Use it when certain conditions make the object impossible to create (like invalid input). The result is an Optional that must be unwrapped before use.
> 2. Use a `convenience init` when you want a shortcut that delegates to the designated init. Default parameter values are cleaner when you only need a single init.
>
> **Challenge Solution**
> ```swift
> class Product {
>     var name: String
>     var price: Double
>
>     init?(name: String, price: Double) {
>         guard price >= 0 else { return nil }
>         self.name = name
>         self.price = price
>     }
>
>     convenience init() {
>         self.init(name: "Untitled", price: 0.0)!
>     }
> }
> ```
>
> The `init?` uses `guard` to exit early if `price` is negative, returning `nil` instead of creating a `Product` with invalid data. The `convenience init()` force-unwraps the result because `price = 0.0` is always valid — the force unwrap is safe here.