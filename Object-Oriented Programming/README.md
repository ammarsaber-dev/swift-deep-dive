# Object-Oriented Programming

Object-Oriented Programming, or OOP, is a way to structure your code around objects. Each object has related properties and methods together instead of spreading them everywhere.

## Before OOP

Say you want to create a shooting game, the game has:

- A customizable character (skin, eye color, size and so on).
- A customizable weapon with different skins.
- Monsters with different shapes, strength and health.

For every action you would create a separate function, a shooting function, a character function, a skin function, a monster function. The game works fine, but nothing is connected to each other.

Now you wanted to add a new feature where the player can level up and on each level the game gives him a new title and skin, that would be a nightmare! Now you have to go and edit multiple separate functions (character, skin, level) just for one feature, change one thing and you risk breaking another.

## With OOP

OOP came to solve this by letting you group everything related into one place.

Now you can create a `Character` class that holds every property and function related to the character, a `Monster` class that holds everything about monsters, and if you need a `Dragon` you can inherit from `Monster` and only add what makes it different.

The code is organized, easier to maintain, and adding new features doesn't mean editing code all over the place.

---

## Prerequisites

- Basic Swift syntax: variables, functions, optionals, and basic types

## How to Use

Each chapter builds on the previous one. Follow them in order. Every chapter includes:

- A real-world analogy to ground the concept
- Code examples with common compiler errors shown inline
- Review questions and coding challenges at the end

## Chapters

| #   | Chapter                                                                              | What You'll Learn                                                             |
| --- | ------------------------------------------------------------------------------------ | ----------------------------------------------------------------------------- |
| 1   | [Class, Object and Constructor](1.%20Class,%20Object%20and%20Constructor/README.md)  | Blueprints, instances, `let` vs `var` references                              |
| 2   | [Properties and Methods](2.%20Properties%20and%20Methods/README.md)                  | Stored properties, instance methods, `self`                                   |
| 3   | [Objects in Memory](3.%20Objects%20in%20Memory/README.md)                            | Reference types, pointers, shared vs independent references                   |
| 4   | [Constructor in Details](4.%20Constructor%20in%20Details/README.md)                  | 8 init patterns: default, custom, delegation, failable, required, convenience |
| 5   | [Encapsulation](5.%20Encapsulation/README.md)                                        | Access control, computed properties, validation                               |
| 6   | [Inheritance](6.%20Inheritance/README.md)                                            | Subclassing, overriding, `super`, `final`, property observers                 |
| 7   | [Composition](7.%20Composition/README.md)                                            | "Has-a" vs "is-a", dependency injection, combining with inheritance           |
| 8   | [Polymorphism](8.%20Polymorphism/README.md)                                          | Compile-time vs runtime, overloading, type casting                            |
| 9   | [Abstraction](Object-Oriented%20Programming/10.%20Abstraction/README.md)             | `fatalError()`, base class vs protocol, the Swift way                         |
| 10  | [Struct vs Class](Object-Oriented%20Programming/11.%20Struct%20vs%20Class/README.md) | Value vs reference types, mutability, when to use which                       |

## Dependency Graph

```
1. Class/Object/Constructor
   ├── 2. Properties & Methods
   │     └── 3. Objects in Memory
   ├── 4. Constructor in Details
   ├── 5. Encapsulation
   └── 6. Inheritance
         ├── 7. Composition
         └── 8. Polymorphism
               └── 9. Abstraction
                     └── 10. Struct vs Class
```

## Next Steps

After completing OOP, continue to [Protocols](../Protocols/README.md).