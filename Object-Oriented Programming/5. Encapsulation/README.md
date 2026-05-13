# Encapsulation

In the [previous topic](Object-Oriented%20Programming/4.%20Constructor%20in%20Details/README.md) we covered the different types of initializers. Now let's control who can access what.

Encapsulation is one of the four pillars of OOP, not everything inside your class should be touched from the outside, you decide what's exposed and what stays hidden.

## The Analogy

Think of a car's engine, you don't need to know how it works internally to drive it. You don't know how fuel gets converted to motion, how the brakes slow you down, or how the gears shift. All of that is hidden from you, you just interact with the pedals and the steering wheel. The car decides what happens internally when you press the gas.

That's exactly what encapsulation does in code, but what happens when nothing is hidden?

## The Problem

Without encapsulation everything inside a class is exposed, anyone can read or modify anything directly. Say you're working in a team and another developer directly sets the speed of a car to a value that makes no sense:

```swift
car1.speed = -999
```

Nothing stops them, no validation, no control, nothing. Now your app is running with a car that has a speed of -999 and you have no idea where it came from. That's the problem. Swift gives you the tools to prevent this, and that's what we'll cover next.

## Access Control in Swift

Swift gives you access levels to control who can access what inside your code, think of it as setting permissions, some things are for everyone, some are for the class only.

### `private`

Only accessible inside the same class, nothing outside can read or modify it:

```swift
class Car {
    private var speed: Double = 0.0
}

let car1 = Car()
car1.speed = 100 // error: 'speed' is inaccessible due to 'private' protection level
```

#### `private(set)`

What if you want a property to be readable from anywhere but only writable from inside the class? that's what `private(set)` is for:

```swift
class Car {
    private(set) var speed: Double = 0.0

    func accelerate() {
        speed += 10
    }
}

let car1 = Car()
print(car1.speed) // 0.0 — reading works fine
car1.speed = 100  // error: cannot assign to property: 'speed' setter is inaccessible
car1.accelerate() // speed is now 10.0
```

Readable from outside, but only the class itself can change it, that's the sweet spot for most properties.

### `internal`

The default access level in Swift, accessible anywhere within the same module (your app). You don't need to write it explicitly, Swift applies it by default, so every property and method you've written so far in these notes has been `internal`without you even knowing:

```swift
class Car {
    var speed: Double = 0.0 // internal by default
}
```

### `public`

Accessible from anywhere, including other modules (frameworks, packages), you'll use this when building a framework or a package that others will use:

```swift
public class Car {
    public var brand: String

    public init(brand: String) {
        self.brand = brand
    }
}
```

### Methods

Access levels apply to methods too, not just properties, so you can hide internal methods that nobody outside the class should call:

```swift
class Car {
    private(set) var speed: Double = 0.0

    func accelerate() {
        increaseSpeed()
        print("Accelerating, speed is now \(speed)")
    }

    private func increaseSpeed() {
        speed += 10
    }
}

let car1 = Car()
car1.accelerate()     // works fine
car1.increaseSpeed()  // error: 'increaseSpeed' is inaccessible due to 'private' protection level
```

`increaseSpeed()` is an internal detail that only `accelerate()` uses, there's no reason for the outside world to call it directly, so we hide it with `private`.

### Bonus: `fileprivate` and `open`

- `fileprivate`: like `private` but a bit more open, anything in the same file can access it, useful when two classes in the same file need to share something without exposing it to the whole app.
- `open`: like `public` but goes one step further, other modules can not only use your class but also subclass it and override its methods, you'll see this a lot in UIKit.

They are not common in day to day iOS development, but knowing they exist will save you from confusion when you see them in someone else's code.

## Getters and Setters

What if you want to control how a property is read or written? like validating a value before setting it or computing a value before returning it? that's what getters and setters are for.

You could do this with functions:

```swift
func getSpeed() -> Double {
    return _speed
}

func setSpeed(_ newSpeed: Double) {
    if newSpeed < 0 {
        print("Speed can't be negative")
    } else {
        _speed = newSpeed
    }
}
```

It works, but it's not the Swift way, computed properties with `get` and `set` are cleaner and feel like you're just working with a regular property instead of calling functions:

```swift
car1.speed = 100  // vs car1.setSpeed(100)
print(car1.speed) // vs print(car1.getSpeed())
```

A getter is a block that runs when you read a property, a setter is a block that runs when you write to it.

### Getter Only

You can have a getter without a setter, this makes the property read-only:

```swift
class Car {
    private var _speed: Double = 0.0

    var speed: Double {
        get {
            return _speed
        }
    }
}

let car1 = Car()
print(car1.speed) // 0.0
car1.speed = 100  // error: cannot assign to property: 'speed' is a get-only property
```

### Getter and Setter

You can also add a setter to control how the property is written, inside the setter Swift gives you a special value called `newValue` which is the value the caller is trying to set:

```swift
class Car {
    private var _speed: Double = 0.0

    var speed: Double {
        get {
            return _speed
        }
        set {
            if newValue < 0 {
                print("Speed can't be negative")
            } else {
                _speed = newValue
            }
        }
    }
}

let car1 = Car()
car1.speed = 100  // works fine
car1.speed = -10  // "Speed can't be negative"
print(car1.speed) // 100.0
```

The real `_speed` property is private and hidden, `speed` is the only way to interact with it and it validates the value before setting it.

## Code

Putting it all together with the `Car` class:

```swift
class Car {
    // public: readable and writable from anywhere
    let brand: String
    let manufactureYear: Int
    var color: String

    // private(set): readable from anywhere, only writable from inside the class
    private(set) var speed: Double

    // private: only accessible inside the class
    private var _fuelLevel: Double = 100.0

    // getter and setter: controls how fuelLevel is read and written
    var fuelLevel: Double {
        get {
            return _fuelLevel
        }
        set {
            if newValue < 0 || newValue > 100 {
                print("Invalid fuel level")
            } else {
                _fuelLevel = newValue
            }
        }
    }

    init(brand: String, manufactureYear: Int, color: String) {
        self.brand = brand
        self.manufactureYear = manufactureYear
        self.color = color
        self.speed = 0.0
    }

    func accelerate() {
        speed += 10
        print("Accelerating, speed is now \(speed)")
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
        print("Engine stopped")
    }
}

let car1 = Car(brand: "Toyota", manufactureYear: 2020, color: "Red")

// private(set) in action
print(car1.speed)   // 0.0
car1.accelerate()   // "Accelerating, speed is now 10.0"
car1.speed = 100    // error: cannot assign to property: 'speed' setter is inaccessible

// getter and setter in action
car1.fuelLevel = 50   // works fine
car1.fuelLevel = -10  // "Invalid fuel level"
print(car1.fuelLevel) // 50.0

// private in action
print(car1._fuelLevel) // error: '_fuelLevel' is inaccessible due to 'private' protection level
```

The internal details are hidden, the outside world only interacts with what you expose, and you control everything that happens in between.


## Key Takeaways

- Access control (`private`, `private(set)`, etc.) decides what's visible from outside the class.
- `private(set)` allows reading from outside but only writing from inside.
- Computed properties with getters and setters let you validate or transform values.


## Try It Yourself

**Review Questions**
1. What's the difference between `private` and `private(set)`?
2. What is `newValue` in a setter, and where does it come from?

**Challenge**
Implement a `Thermostat` class with a `private(set) var temperature: Double`. Provide `increase()` and `decrease()` methods that adjust by 1 degree, clamping the value between 10 and 30. The `init` should also clamp the initial value.

> [!faq]- Answers (click to reveal)
>
> **Review Questions**
> 1. `private` means not readable or writable from outside the class. `private(set)` means readable from anywhere but only writable from inside the class.
> 2. `newValue` is the value the caller is trying to set. Swift provides it automatically inside a setter.
>
> **Challenge Solution**
> ```swift
> class Thermostat {
>     private(set) var temperature: Double
>
>     init(temperature: Double) {
>         self.temperature = min(max(temperature, 10), 30)
>     }
>
>     func increase() {
>         if temperature < 30 {
>             temperature += 1
>             print("Temperature is now \(temperature)")
>         } else {
>             print("Already at maximum temperature")
>         }
>     }
>
>     func decrease() {
>         if temperature > 10 {
>             temperature -= 1
>             print("Temperature is now \(temperature)")
>         } else {
>             print("Already at minimum temperature")
>         }
>     }
> }
> ```