# Polymorphism

In the [previous topic](Object-Oriented%20Programming/7.%20Composition/README.md) we covered composition. Now let's look at the fourth pillar: polymorphism.

Polymorphism is one of the four pillars of OOP, the word itself comes from Greek and means "many forms", and that's exactly what it is, the ability of objects to take on many forms.

## What is Polymorphism?

Polymorphism means you can treat objects of different classes as if they have the same type, as long as they share a common superclass.

Think of a remote control, it has a volume button, and it doesn't care if the TV is a Samsung, LG, or Sony, it just sends the signal and each TV responds in its own way. The button is the same, the behavior is different.

That's polymorphism, one interface, many behaviors.

## Compile-time vs Runtime Polymorphism

Before we go deeper, there are two types of polymorphism in Swift and it's important to know the difference.

**Compile-time polymorphism** is decided when the code is compiled, before the app even runs. Swift looks at your code and picks the right function or operator based on the types you used. Method overloading and operator overloading are compile-time polymorphism.

**Runtime polymorphism** is decided while the app is running. Swift looks at the actual type of the object at that moment and calls the right method. Method overriding and subtype polymorphism are runtime polymorphism.

A simple way to think about it: compile-time is Swift deciding, runtime is the app deciding.

## Subtype Polymorphism

This is the most common form of polymorphism and it builds directly on top of inheritance. Because a subclass inherits from a superclass, you can treat a subclass object as if it's a superclass object.

```swift
class Vehicle {
    func makeNoise() {
        print("Some noise")
    }
}

class Car: Vehicle {
    override func makeNoise() {
        print("Vroom!")
    }
}

class Train: Vehicle {
    override func makeNoise() {
        print("Choo Choo!")
    }
}
```

Now here's the interesting part, you can store different types in the same array as long as they share the same superclass:

```swift
let vehicles: [Vehicle] = [Car(), Train(), Vehicle()]

for vehicle in vehicles {
    vehicle.makeNoise()
}
// "Vroom!"
// "Choo Choo!"
// "Some noise"
```

`vehicles` is an array of `Vehicle`, but it holds a `Car` and a `Train` too, because both are vehicles. When you call `makeNoise()` on each one, Swift calls the right version based on the actual type of the object, not the type of the array. That's subtype polymorphism.

## Method Overriding

You already saw this in the Inheritance notes, a subclass can provide its own version of a method it inherits from its superclass using the `override` keyword:

```swift
class Vehicle {
    func makeNoise() {
        print("Some noise")
    }
}

class Car: Vehicle {
    override func makeNoise() {
        print("Vroom!")
    }
}

let car = Car()
car.makeNoise() // "Vroom!" — Car's version is called, not Vehicle's
```

Same method name, different behavior depending on the object. That's method overriding and it's the most common form of runtime polymorphism in Swift.

## Method Overloading

Method overloading is when you have multiple functions with the same name but different parameters, Swift picks the right one based on what you pass:

```swift
func drive(speed: Int) {
    print("Driving at \(speed) km/h")
}

func drive(speed: Double) {
    print("Driving at \(speed) km/h")
}

func drive(speed: Int, gear: Int) {
    print("Driving at \(speed) km/h in gear \(gear)")
}

drive(speed: 100)          // "Driving at 100 km/h"
drive(speed: 99.5)         // "Driving at 99.5 km/h"
drive(speed: 100, gear: 3) // "Driving at 100 km/h in gear 3"
```

Swift decides which `drive` to call at compile time based on the types and number of parameters you pass. Same name, different behavior — that's method overloading.

Note: overloading happens inside the same class or scope, overriding happens in subclasses. They are different things.

## Operator Overloading

Operator overloading is the same idea as method overloading but for operators like `+`, `-`, `*`, and so on. You can define what an operator does for your own types:

```swift
class Speed {
    var value: Double

    init(value: Double) {
        self.value = value
    }

    static func + (lhs: Speed, rhs: Speed) -> Speed {
        return Speed(value: lhs.value + rhs.value)
    }
}
```

Without operator overloading, `speed1 + speed2` would be an error because Swift doesn't know how to add two `Speed` objects. By defining `+` yourself, you tell Swift exactly what to do. Same operator, different behavior depending on the type — that's operator overloading.

## Type Casting

You will run into situations where you have an object stored as a superclass type, but you need to access something that only exists in the subclass. Type casting lets you convert between types.

Swift gives you three ways to do it.
### 1. `as`

Used when you are 100% sure the conversion will work, for example upcasting (going from subclass to superclass):

```swift
let car = Car()
let vehicle = car as Vehicle // always works, Car is a Vehicle
```

### 2. `as?`

Used when the conversion might fail, it returns an optional so if the conversion fails you get `nil` instead of a crash:

```swift
let vehicles: [Vehicle] = [Car(), Train()]

for vehicle in vehicles {
    if let car = vehicle as? Car {
        print("This is a car")
    } else if let train = vehicle as? Train {
        print("This is a train")
    }
}
// "This is a car"
// "This is a train"
```

### 3. `as!`

Used when you are absolutely sure the conversion will work, if you are wrong the app will crash, so use it carefully:

```swift
let vehicle: Vehicle = Car()
let car = vehicle as! Car // you are sure this is a Car, if not — crash
print(car.makeNoise())
```

A good rule: always prefer `as?` over `as!`, the optional is safer and won't crash your app if you're wrong.

## Putting it all Together

Polymorphism is what makes your code flexible and easy to extend. Instead of writing separate code for every type, you write one interface and let each type handle it in its own way:

```swift
class Vehicle {
    var name: String

    init(name: String) {
        self.name = name
    }

    func makeNoise() -> String {
        return "..."
    }
}

class Car: Vehicle {
    override func makeNoise() -> String {
        return "Vroom!"
    }
}

class Train: Vehicle {
    override func makeNoise() -> String {
        return "Choo Choo!"
    }
}

class Bicycle: Vehicle {
    override func makeNoise() -> String {
        return "Swoosh!"
    }
}

let vehicles: [Vehicle] = [
    Car(name: "Toyota"),
    Train(name: "Bullet Train"),
    Bicycle(name: "Trek")
]

for vehicle in vehicles {
    print("\(vehicle.name): \(vehicle.makeNoise())")

    if let car = vehicle as? Car {
        print("  -> This is a car")
    }
}
// "Toyota: Vroom!"
// "  -> This is a car"
// "Bullet Train: Choo Choo!"
// "Trek: Swoosh!"
```

One loop, one method call, but each object responds in its own way. That's the power of polymorphism.


## Key Takeaways

- Subtype polymorphism lets you treat objects of different classes as their common superclass.
- Method overriding gives each type its own behavior through the same interface.
- Method overloading lets multiple methods share a name with different parameters.
- Prefer `as?` over `as!` for safe type casting.


## Try It Yourself

**Review Questions**
1. What's the difference between compile-time polymorphism and runtime polymorphism?
2. When would you use `as?` instead of `as!` for type casting?

**Challenge**
Create a `Shape` base class with a `func draw()` method. Then create `Circle`, `Square`, and `Triangle` subclasses that override `draw()`. Add them to a polymorphic `[Shape]` array. In the loop, use `as?` to print "This is a circle!" when the shape is a `Circle`.

> [!faq]- Answers (click to reveal)
>
> **Review Questions**
> 1. Compile-time polymorphism is decided during compilation (method overloading, operator overloading). Runtime polymorphism is decided while the app runs (method overriding, subtype polymorphism).
> 2. Use `as?` when you're not sure about the type — it returns an Optional that won't crash if you're wrong. Use `as!` only when you are 100% certain.
>
> **Challenge Solution**
> ```swift
> class Shape {
>     func draw() {
>         print("Drawing a shape")
>     }
> }
>
> class Circle: Shape {
>     override func draw() { print("Drawing a circle") }
> }
>
> class Square: Shape {
>     override func draw() { print("Drawing a square") }
> }
>
> class Triangle: Shape {
>     override func draw() { print("Drawing a triangle") }
> }
>
> let shapes: [Shape] = [Circle(), Square(), Triangle()]
>
> for shape in shapes {
>     shape.draw()
>
>     if let _ = shape as? Circle {
>         print("  -> This is a circle!")
>     }
> }
> ```