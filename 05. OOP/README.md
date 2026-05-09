# Object-Oriented Programming in Swift

Swift is a multi-paradigm language — it supports **protocol-oriented programming**, **functional programming**, and **object-oriented programming**. This section focuses on the OOP side: the four pillars that define how objects interact, share behaviour, and hide complexity.

A quick note before diving in: Swift **prefers value types** over reference types and **protocols over class inheritance**. The OOP patterns here still apply — you'll just reach for `struct` + `protocol` more often than `class` + `superclass`. Keep that in mind as you read.

---

## Encapsulation

> Bundle data and behaviour together, and control access to internals.

Encapsulation means hiding the internal state of an object and only exposing a controlled interface. In Swift, access control is the tool:

| Keyword | Visibility |
|---|---|
| `open` | Visible and subclassable outside the module |
| `public` | Visible but not subclassable outside the module |
| `internal` | Visible within the module (default) |
| `fileprivate` | Visible within the same file |
| `private` | Visible within the same declaration |

**❌ No encapsulation**

```swift
struct BankAccount {
    var balance: Double = 0
}

var account = BankAccount()
account.balance = -500  // directly modifiable — no validation
```

**✅ Encapsulated**

```swift
struct BankAccount {
    private(set) var balance: Double = 0

    mutating func deposit(_ amount: Double) {
        guard amount > 0 else { return }
        balance += amount
    }

    mutating func withdraw(_ amount: Double) -> Bool {
        guard amount > 0, amount <= balance else { return false }
        balance -= amount
        return true
    }
}

var account = BankAccount()
account.deposit(100)
account.withdraw(30)
print(account.balance) // 70
```

The balance is read-only from outside. All mutations go through methods that enforce rules.

### Property observers

A Swift-specific tool for encapsulation — react to changes without exposing setter logic:

```swift
struct Temperature {
    private var _celsius: Double = 0

    var celsius: Double {
        get { _celsius }
        set { _celsius = newValue }
    }

    var fahrenheit: Double {
        get { _celsius * 9 / 5 + 32 }
        set { _celsius = (newValue - 32) * 5 / 9 }
    }
}
```

Computed properties let you expose a different view of internal data without sacrificing encapsulation.

---

## Inheritance

> A class can inherit behaviour from another class.

Swift restricts inheritance to classes — structs and enums don't support it. A class can inherit methods, properties, and other characteristics from a parent class.

**❌ Overusing inheritance when composition would work**

```swift
class Animal {
    func makeSound() { fatalError("override me") }
}

class Dog: Animal {
    override func makeSound() { print("Bark") }
}

class Cat: Animal {
    override func makeSound() { print("Meow") }
}
```

This works but scales poorly. A `Robot` that needs `makeSound()` but isn't an `Animal` can't participate without restructuring the hierarchy.

**✅ Protocol-oriented alternative**

```swift
protocol SoundMaking {
    func makeSound()
}

struct Dog: SoundMaking {
    func makeSound() { print("Bark") }
}

struct Cat: SoundMaking {
    func makeSound() { print("Meow") }
}

struct Robot: SoundMaking {
    func makeSound() { print("Beep boop") }
}
```

No forced hierarchy — any type can conform. This is the idiomatic Swift approach.

### When class inheritance makes sense

```swift
class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    func setupUI() { /* subclasses override */ }
}

class ProfileViewController: ViewController {
    override func setupUI() { /* profile-specific UI */ }
}
```

Apple's UIKit is class-based. When working within UIKit or AppKit, you inherit. Everywhere else, prefer protocols and composition.

### Key rules

- A class can only inherit from **one** parent class
- `override` is explicit — Swift won't let you override accidentally
- `final` prevents further subclassing
- `super` calls the parent's implementation

---

## Polymorphism

> Different types respond to the same interface in their own way.

Polymorphism lets you write code that works with any type conforming to a protocol, without knowing the concrete type at compile time.

**❌ Type-checking dispatch**

```swift
func playAudio(_ source: Any) {
    if let radio = source as? Radio {
        radio.play()
    } else if let podcast = source as? Podcast {
        podcast.start()
    } else if let spotify = source as? Spotify {
        Spotify.playTrack()  // different API every time
    }
}
```

**✅ Protocol-based polymorphism**

```swift
protocol AudioSource {
    func play()
}

struct Radio: AudioSource {
    func play() { /* tune frequency, play */ }
}

struct Podcast: AudioSource {
    func play() { /* stream episode, play */ }
}

struct Spotify: AudioSource {
    func play() { /* fetch token, play track */ }
}

func playAudio(_ source: AudioSource) {
    source.play()   // knows nothing about the concrete type
}

playAudio(Radio())
playAudio(Podcast())
playAudio(Spotify())
```

Each type implements `play()` in its own way. The caller doesn't care how — it just calls the interface.

### Static vs dynamic dispatch

Swift uses two dispatch strategies:

| Dispatch | Mechanism | Speed | When |
|---|---|---|---|
| **Static** | Direct function call | Fastest | Structs, `final` classes, generics |
| **Dynamic** | vtable lookup (class) or witness table (protocol) | Slightly slower | Non-final classes, protocol existential containers |

Swift prefers static dispatch by default (structs, `final` classes). Dynamic dispatch is opt-in through protocols or non-final classes.

---

## Abstraction

> Hide complexity behind a clean interface.

Abstraction means exposing only what's necessary and hiding implementation details. Protocols are Swift's primary abstraction mechanism.

**❌ Leaky abstraction**

```swift
struct PaymentProcessor {
    func processCreditCard(number: String, cvv: String, expiry: String, amount: Double) {
        // validate
        // encrypt
        // send to Stripe API
        // handle response
        // log
    }
}
```

The caller knows too much — credit card details, payment provider, validation rules.

**✅ Clean abstraction**

```swift
protocol PaymentMethod {
    func charge(amount: Double) async throws
}

struct CreditCard: PaymentMethod {
    private let number: String
    private let cvv: String
    private let expiry: String

    func charge(amount: Double) async throws {
        // validate, encrypt, send to Stripe, handle response
    }
}

struct ApplePay: PaymentMethod {
    private let token: String

    func charge(amount: Double) async throws {
        // use Apple Pay token, handle response
    }
}

struct Checkout {
    func purchase(item: String, using method: PaymentMethod) async throws {
        let price = await fetchPrice(for: item)
        try await method.charge(amount: price)
    }
}
```

`Checkout` knows nothing about credit card fields, encryption, or Stripe. It only knows `PaymentMethod`. The abstraction is clean.

### Protocol extensions — abstraction with defaults

```swift
protocol Logger {
    func log(_ message: String)
}

extension Logger {
    func logError(_ error: Error) {
        log("[ERROR] \(error.localizedDescription)")
    }
}

struct ConsoleLogger: Logger {
    func log(_ message: String) {
        print(message)
    }
}

let logger = ConsoleLogger()
logger.logError(CocoaError(.fileNoSuchFile))  // uses protocol extension
```

The protocol defines the minimum requirement (`log`), and the extension provides convenience methods built on top. New conformers get `logError` for free.

---

## Value Types vs Reference Types in OOP

This is the Swift-specific twist that affects every OOP decision:

| | Struct (value) | Class (reference) |
|---|---|---|
| Assignment | Copies data | Shares reference |
| Mutation | Requires `mutating` | Free mutation |
| Inheritance | Not supported | Supported |
| Identity | `==` (equatable) | `===` (identity) |
| When to use | Plain data, no side effects | Shared state, identity matters |

**Rule of thumb:** Start with a struct. Use a class only when you need reference semantics or inheritance from an Apple framework class.

---

## Quick Reference

| Pillar | Swift Tool |
|---|---|
| Encapsulation | Access control (`private`, `private(set)`), computed properties |
| Inheritance | Class inheritance + `override`, but prefer protocols + composition |
| Polymorphism | Protocols with method implementations |
| Abstraction | Protocols, protocol extensions with default implementations |
