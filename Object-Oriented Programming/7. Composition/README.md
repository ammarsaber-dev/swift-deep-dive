# Composition

In the [previous topic](Object-Oriented%20Programming/6.%20Inheritance/README.md) we covered inheritance. Now let's look at an alternative way to compose behavior.

You've learned inheritance, and it's great, but it's not always the right tool. Sometimes you don't want a class to **be** something, you want it to **have** something, that's where composition comes in.

## What is Composition?

Instead of saying "a Car **is a** Vehicle" you say "a Car **has an** Engine, **has a** GearBox, **has** Wheels", that's the core idea of composition, you build a class by combining smaller focused classes together.

Think of how a real car is made, the manufacturer doesn't sit down and build one giant thing called a car, they build an engine, a gearbox, wheels, seats separately, and then put them all together. Each part does one job and does it well, the car is just the thing that holds them together.

That's exactly what composition does in code, you build small focused classes and combine them to create something bigger. But when do you use composition over inheritance?

## Inheritance vs Composition

Both let you reuse code, but they solve different problems and picking the wrong one will make your life harder later.

**Inheritance** is for when one thing **is a** type of another:

```swift
class Car: Vehicle { } // a Car is a Vehicle
class Dog: Animal { }  // a Dog is an Animal
```

**Composition** is for when one thing **has** another:

```swift
class Car {
    let engine: Engine   // a Car has an Engine
    let gearBox: GearBox // a Car has a GearBox
}
```

The problem with inheritance shows up when things get more complex. Say you want a `FlyingCar`, it's a car but it can also fly. Do you inherit from `Car` or from `Plane`? you can't inherit from both in Swift, you're stuck. With composition you just give it whatever it needs:

```swift
class FlyingCar {
    let engine: Engine
    let gearBox: GearBox
    let wings: Wings
    // add whatever you need, no limits
}
```

A simple rule: if you find yourself saying "is a" use inheritance, if you find yourself saying "has a" use composition.

Another issue with inheritance is that subclasses are tightly connected to their superclass, a small change up there can break something down here in ways you don't expect. With composition each piece lives on its own, changes in one don't touch the others.

> [!warning]- Common mistake: "forcing inheritance when you need composition"
> If you find yourself creating deep class hierarchies or overriding methods just to tweak small behaviors, you probably need composition instead. Ask yourself: is it really an "is a" relationship? If the subclass doesn't fully satisfy the superclass contract, composition is the better choice.

Now let's see what it looks like when a class tries to do too many things at once:

```swift
// bad: Car is doing everything itself
class Car {
    var speed: Double = 0.0
    var gear: Int = 1
    var horsepower: Int = 300

    func startEngine() { print("Engine started with \(horsepower)hp") }
    func stopEngine() { print("Engine stopped") }
    func shiftUp() { gear += 1 }
    func shiftDown() { if gear > 1 { gear -= 1 } }
    func accelerate() { speed += 10; shiftUp() }
}
```

Now imagine you want an `ElectricCar`, it has no gearbox and no engine horsepower, but now you're stuck with all of that baked into the class. This is the kind of mess that composition saves you from, so let's see how to do it right.

## Code

Instead of one big class, we split things into small focused pieces, each class has one job:

```swift
class Engine {
    var horsepower: Int

    init(horsepower: Int) {
        self.horsepower = horsepower
    }

    func start() {
        print("Engine started with \(horsepower)hp")
    }

    func stop() {
        print("Engine stopped")
    }
}

class GearBox {
    private(set) var currentGear = 1

    func shiftUp() {
        currentGear += 1
        print("Shifted up to gear \(currentGear)")
    }

    func shiftDown() {
        if currentGear > 1 {
            currentGear -= 1
            print("Shifted down to gear \(currentGear)")
        }
    }
}

class Car {
    let engine: Engine
    let gearBox: GearBox
    var currentSpeed = 0.0

    // we pass Engine and GearBox from outside instead of creating them inside Car,
    // this is called Dependency Injection, it makes each piece easier to change and test on its own.
    init(engine: Engine, gearBox: GearBox) {
        self.engine = engine
        self.gearBox = gearBox
    }

    func start() { engine.start() }
    func stop() { engine.stop() }

    func accelerate() {
        currentSpeed += 10
        gearBox.shiftUp()
        print("Speed is now \(currentSpeed)")
    }
}
```

`shiftUp()` is called every time for simplicity, in a real car gear shifting depends on speed and engine load.

```swift
let engine = Engine(horsepower: 300)
let gearBox = GearBox()
let car = Car(engine: engine, gearBox: gearBox)

car.start()      // "Engine started with 300hp"
car.accelerate() // "Shifted up to gear 2" — "Speed is now 10.0"
car.accelerate() // "Shifted up to gear 3" — "Speed is now 20.0"
car.stop()       // "Engine stopped"
```

Now here's where it gets interesting, remember the `ElectricCar` problem from earlier? with composition you just swap the engine, nothing else needs to change:

```swift
class ElectricEngine {
    var batteryLevel: Double

    init(batteryLevel: Double) {
        self.batteryLevel = batteryLevel
    }

    func start() {
        print("Electric motor started, battery at \(batteryLevel)%")
    }

    func stop() {
        print("Electric motor stopped")
    }
}

let electricEngine = ElectricEngine(batteryLevel: 100)
let electricCar = Car(engine: electricEngine, gearBox: GearBox())
electricCar.start() // "Electric motor started, battery at 100.0%"
```

Wait, `Car` expects an `Engine` not an `ElectricEngine`, this is where protocols come in and we will cover that in a later section.

## Using Both

You don't have to pick one or the other, most real code uses both together, inheritance for the "is a" relationships and composition for the "has a" relationships:

```swift
class Vehicle {
    var currentSpeed = 0.0

    var description: String {
        return "traveling at \(currentSpeed) miles per hour"
    }
}

// Car is a Vehicle (inheritance) and has an Engine and GearBox (composition)
class Car: Vehicle {
    let engine: Engine
    let gearBox: GearBox

    init(engine: Engine, gearBox: GearBox) {
        self.engine = engine
        self.gearBox = gearBox
    }

    override var description: String {
        return super.description + " in gear \(gearBox.currentGear)"
    }
}

let engine = Engine(horsepower: 300)
let gearBox = GearBox()
let car = Car(engine: engine, gearBox: gearBox)

car.currentSpeed = 25.0
print(car.description) // "traveling at 25.0 miles per hour in gear 1"
```

`Car` inherits from `Vehicle` because a car **is a** vehicle, and it has an `Engine` and a `GearBox` because a car **has** those things. Inheritance gives you the structure, composition gives you the flexibility. Together they give you both.


## Key Takeaways

- Inheritance models "is a" relationships; composition models "has a" relationships.
- Composition combines small focused classes to build larger ones.
- Dependency injection passes components from outside rather than creating them inside.
- Inheritance and composition work best when used together.


## Try It Yourself

**Review Questions**
1. What's the difference between an "is a" relationship and a "has a" relationship?
2. What is dependency injection and why is it useful?

**Challenge**
Compose a `Restaurant` class from `Chef`, `Menu`, and `Location` classes. Each component should have a `describe()` method. Use dependency injection in `Restaurant`'s init to receive these components, and add an `open()` method that calls each component's `describe()`.

> [!faq]- Answers (click to reveal)
>
> **Review Questions**
> 1. "Is a" describes inheritance (a Car IS A Vehicle). "Has a" describes composition (a Car HAS an Engine).
> 2. Dependency injection means passing dependencies into a class from outside instead of creating them inside. It makes each piece easier to test and swap independently.
>
> **Challenge Solution**
> ```swift
> class Chef {
>     let name: String
>     init(name: String) { self.name = name }
>     func describe() { print("Chef: \(name)") }
> }
>
> class Menu {
>     let items: [String]
>     init(items: [String]) { self.items = items }
>     func describe() { print("Menu: \(items.joined(separator: ", "))") }
> }
>
> class Location {
>     let address: String
>     init(address: String) { self.address = address }
>     func describe() { print("Location: \(address)") }
> }
>
> class Restaurant {
>     let chef: Chef
>     let menu: Menu
>     let location: Location
>
>     init(chef: Chef, menu: Menu, location: Location) {
>         self.chef = chef
>         self.menu = menu
>         self.location = location
>     }
>
>     func open() {
>         chef.describe()
>         menu.describe()
>         location.describe()
>     }
> }
>
> let restaurant = Restaurant(
>     chef: Chef(name: "Gordon"),
>     menu: Menu(items: ["Steak", "Salad", "Pasta"]),
>     location: Location(address: "123 Main St")
> )
> restaurant.open()
> ```