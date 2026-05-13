# Objects in Memory

In the [previous topic](Object-Oriented%20Programming/2.%20Properties%20and%20Methods/README.md) we created objects from a class like this:

```swift
let car1 = Car(brand: "Toyota", manufactureYear: 2020, color: "Red", speed: 0.0)
```

But `car1` is not actually an object. It's a pointer (reference) to an object that lives somewhere in memory. It's just a way to access and interact with that object.

## Each Reference has its own Object

Because each reference points to its own object in memory, editing a property of one doesn't affect the other:

```swift
var car3 = Car(brand: "Mercedes", manufactureYear: 2025, color: "White", speed: 0.0)
let car4 = Car(brand: "Ford", manufactureYear: 2026, color: "Orange", speed: 0.0)

car3.color = "Green"
print(car3.color) // "Green"
print(car4.color) // "Orange" (not affected by modifying car3's color)
```

## Two References, One Object

But what if two references point to the same object?

```swift
let car5 = car3
car5.color = "Blue"
print(car3.color) // "Blue" — car3 was affected!
print(car5.color) // "Blue"
```

We didn't create a new object, we just made `car5` point to the same object as `car3`. So when we changed `car5.color`, `car3.color` changed too because they are both pointing at the same object in memory.

This is what makes classes reference types. You are not working with the object directly, you are working with a reference that points to it. Any reference that points to the same object will see the same changes.

> [!warning]- Common mistake: "assignment copies the object"
> `let car5 = car3` does **not** create a copy. Both variables point to the same object in memory. If you want an independent copy, you must create a new object manually. This is a common source of bugs when you expect two separate objects.

> [!warning]- Common mistake: "`let` freezes the object"
> `let` only prevents the reference from pointing to a different object. The object itself can still be modified through that reference. `car5.color = "Blue"` works even though `car5` was declared with `let`.


## Key Takeaways

- Variables hold references to objects, not the objects themselves.
- Assigning a reference to another variable shares the object — it doesn't copy it.
- Any change through one reference is visible through all references pointing to the same object.


## Try It Yourself

**Review Questions**
1. In `let car1 = Car(brand: "Toyota", manufactureYear: 2020, color: "Red", speed: 0.0)`, is `car1` the actual object or a reference to it?
2. If you write `let car5 = car3` and then change `car5.color`, does `car3.color` change? Why?

**Challenge**
Create a `Playlist` class with a `name: String` property and `init(name:)`. Create a playlist `p1`, then assign `let p2 = p1`. Change `p2.name` and print both `p1.name` and `p2.name`. What do you see, and why?

> [!faq]- Answers (click to reveal)
>
> **Review Questions**
> 1. `car1` is a reference (pointer) to the object, not the object itself. The object lives somewhere in memory, and `car1` stores the address of that location. You interact with the object through this reference.
> 2. Yes. `let car5 = car3` copies the reference, not the object. Both variables now hold the same memory address — they point to the exact same object. So a change through one reference (`car5.color = "Blue"`) is immediately visible through the other (`car3.color`). This is what it means for classes to be reference types.
>
> **Challenge Solution**
> ```swift
> class Playlist {
>     var name: String
>
>     init(name: String) {
>         self.name = name
>     }
> }
>
> let p1 = Playlist(name: "Favorites")
> let p2 = p1
> p2.name = "Chill Vibes"
>
> print(p1.name) // "Chill Vibes"
> print(p2.name) // "Chill Vibes"
> // Both print "Chill Vibes" because p1 and p2 point to the same object.
> ```