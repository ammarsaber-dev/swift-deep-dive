# Inheritance

Inheritance is one of the four pillars of OOP. It lets a class inherit properties and methods from another class, so you don't have to write the same code twice. In the previous notes we built a `Car` class from scratch. Now we will use `Vehicle` as the base class and have `Car` inherit from it.

## The Analogy

Think of a general vehicle. It has a speed, it can move, and it makes some kind of noise. Now think of a car. It's a vehicle but with more specific things like gears. And a bicycle, also a vehicle but with no engine. They all share the same base characteristics but each one has its own specific details on top.

That's exactly what inheritance does in code. You define the shared stuff once and build on top of it.

## Base Class

A base class is a class that doesn't inherit from any other class. It's the starting point that other classes will build on top of.

```swift
class Vehicle {
    var currentSpeed = 0.0

    var description: String {
        return "traveling at \(currentSpeed) miles per hour"
    }

    func makeNoise() {
        // do nothing, a basic vehicle doesn't necessarily make a noise
    }
}

let vehicle = Vehicle()
print(vehicle.description) // "traveling at 0.0 miles per hour"
```

`Vehicle` defines the shared characteristics that every vehicle has, speed and the ability to make a noise.

## Subclassing

A subclass is a class that inherits from another class. It gets everything the superclass has and can add its own things on top.

To create a subclass you write the subclass name followed by a colon and the superclass name:

```swift
class Bicycle: Vehicle {
    var hasBasket = false
}
```

`Bicycle` now has everything `Vehicle` has (`currentSpeed`, `description`, `makeNoise()`) plus its own `hasBasket` property.

```swift
let bicycle = Bicycle()
bicycle.hasBasket = true
bicycle.currentSpeed = 15.0
print(bicycle.description) // "traveling at 15.0 miles per hour"
```

And subclasses can themselves be subclassed. You can go as deep as you want:

```swift
class Tandem: Bicycle {
    var currentNumberOfPassengers = 0
}

let tandem = Tandem()
tandem.hasBasket = true
tandem.currentNumberOfPassengers = 2
tandem.currentSpeed = 22.0
print(tandem.description) // "traveling at 22.0 miles per hour"
```

`Tandem` inherits from `Bicycle` which inherits from `Vehicle`, so it has everything from both.

## Overriding

A subclass can provide its own version of a method or property it inherits from its superclass. This is called overriding. You use the `override` keyword to do it, and Swift will error out if you forget it or if there's no matching definition in the superclass:

### Overriding Methods

```swift
class Train: Vehicle {
    override func makeNoise() {
        print("Choo Choo")
    }
}

let train = Train()
train.makeNoise() // "Choo Choo"
```

`Train` overrides `makeNoise()` with its own version, the superclass version is ignored.

### Overriding Properties

You can also override a property to provide your own getter and setter:

```swift
class Car: Vehicle {
    var gear = 1

    override var description: String {
        return super.description + " in gear \(gear)"
    }
}

let car = Car()
car.currentSpeed = 25.0
car.gear = 3
print(car.description) // "traveling at 25.0 miles per hour in gear 3"
```

Notice `super.description`. We will cover `super` in the next section.

## `super`

When you override a method or property, you replace the superclass version completely. But sometimes you don't want to replace it, you just want to extend it. That's where `super` comes in. It lets you call the superclass version from inside your override.

Without `super`:

```swift
class Car: Vehicle {
    var gear = 1

    override var description: String {
        return "traveling at \(currentSpeed) miles per hour in gear \(gear)"
    }
}
```

With `super`:

```swift
class Car: Vehicle {
    var gear = 1

    override var description: String {
        return super.description + " in gear \(gear)"
    }
}
```

Both produce the same result, but with `super` you don't have to rewrite `"traveling at \(currentSpeed) miles per hour"` yourself, you just call the superclass version and add on top of it. If the superclass ever changes its description, your subclass automatically gets the update too.

## Property Observers on Inherited Properties

Say you want to print a message every time the car's speed changes, or automatically adjust the gear when the car speeds up. You don't need to change how `currentSpeed` works. You just need to react when it changes.

Swift gives you **property observers** for this, two special blocks that run automatically:

- `willSet` runs just before the value changes. The new value is called `newValue`.
- `didSet` runs right after the value changes. The old value is called `oldValue`.

A simple example to see them in action:

```swift
var speed = 0 {
    willSet {
        print("Speed will change to \(newValue)")
    }
    didSet {
        print("Speed changed from \(oldValue) to \(speed)")
    }
}

speed = 50
// "Speed will change to 50"
// "Speed changed from 0 to 50"
```

You add observers directly on your own properties like this. But for an **inherited** property (one that comes from a superclass), you need `override`, because the property belongs to the superclass, not to this class:

```swift
class AutomaticCar: Car {
    override var currentSpeed: Double {
        willSet {
            print("About to change speed to \(newValue)")
        }
        didSet {
            gear = Int(currentSpeed / 10.0) + 1
        }
    }
}

let automatic = AutomaticCar()
automatic.currentSpeed = 35.0
// "About to change speed to 35.0"
// gear is now 4
print(automatic.description) // "traveling at 35.0 miles per hour in gear 4"
```

Every time `currentSpeed` changes, the observers run automatically. `AutomaticCar` didn't have to rewrite any of the speed or gear logic, it just observed the change and reacted to it.

> [!faq]- Why observers instead of overriding? (click to expand)
> Think of it like this:
>
> - **Overriding** is like replacing the engine in your car. The old engine is gone, the new one does the work. You changed *how the thing works*.
> - **Observers** are like adding a beep sound when you reach 100 km/h. The engine works exactly the same, you just added something that reacts on the side. You changed nothing, you just listen.
>
> | | Overriding | Observers |
> |---|---|---|
> | What it does | Replaces the property completely | Adds code that runs before/after a change |
> | Old behavior | Gone | Still works |
> | When to use | You want to change *what* the property does | You want to *react* when it changes |
>
> In our `AutomaticCar` example, we don't want to change how `currentSpeed` works. Speed still stores a number, still returns it the same way. We just want to react when the speed changes and adjust the gear automatically. Observers are perfect for this. They keep the original behavior and add on top of it.

## Preventing Overrides (`final`)

Sometimes you don't want a subclass to override a method, property, or even the whole class. You can use `final` to prevent that. Here's the same `Car` class, now with `final`:

```swift
class Car: Vehicle {
    final var gear = 1

    final func changeGear(to newGear: Int) {
        gear = newGear
    }
}
```

Any attempt to override `gear` or `changeGear()` in a subclass will error out:

```swift
class SportsCar: Car {
    override var gear: Int { ... }        // error: cannot override a final property
    override func changeGear(to:) { ... } // error: cannot override a final method
}
```

You can also mark the entire class as `final` to prevent it from being subclassed at all:

```swift
final class Car: Vehicle {
    // nobody can subclass Car
}

class SportsCar: Car { } // error: cannot inherit from final class 'Car'
```

> [!warning]- Common mistake: "forgetting `override`"
> If a subclass method has the same name and parameters as a superclass method, Swift requires the `override` keyword. Without it, the compiler will error — this protects you from accidentally overriding a method you didn't know existed.

> [!warning]- Common mistake: "overriding when you should observe"
> If you want to add side effects to an inherited property (like logging or updating other values), use property observers (`willSet`/`didSet`), not overriding. Overriding replaces the property entirely, observers just react to changes.


## Key Takeaways

- A subclass inherits everything from its superclass.
- `override` replaces a method or property — `super` extends it.
- Property observers (`willSet`/`didSet`) react to changes without replacing behavior.
- `final` prevents a method, property, or class from being overridden.


## Try It Yourself

**Review Questions**
1. What keyword must you use when providing a new implementation of a superclass method?
2. What's the difference between overriding a property and adding a property observer to an inherited property?

**Challenge**
Create an `Employee` base class with a `func work()` method that prints "Working...". Then create `Manager` and `Developer` subclasses that override `work()`. `Manager` should call `super.work()` first, then print "Managing the team". `Developer` should print "Writing code". Create one of each and call `work()`.

> [!faq]- Answers (click to reveal)
>
> **Review Questions**
> 1. `override`. Swift requires this keyword to prevent accidental overriding. If a superclass method is renamed or removed, subclasses that don't use `override` will produce a compile error instead of silently becoming unrelated methods.
> 2. Overriding replaces the property completely. Observers run before or after the value changes but the property's behavior stays the same.
>
> **Challenge Solution**
> ```swift
> class Employee {
>     func work() {
>         print("Working...")
>     }
> }
>
> class Manager: Employee {
>     override func work() {
>         super.work()
>         print("Managing the team")
>     }
> }
>
> class Developer: Employee {
>     override func work() {
>         print("Writing code")
>     }
> }
>
> let manager = Manager()
> let developer = Developer()
> manager.work() // "Working..." then "Managing the team"
> developer.work() // "Writing code"
> ```