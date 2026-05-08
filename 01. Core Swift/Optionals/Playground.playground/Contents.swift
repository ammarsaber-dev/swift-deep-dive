// MARK: Declaring Optionals

var name: String? // defaults to nil
var age: Int? = 28
var score: Double? = nil // same as the first example


// ========================================================================================

// MARK: Unwrapping Techniques

// 1. if let

let myName: String? = "Ammar"

// use the same name of the optional var
if let myName {
    print("Hello \(myName)!")
} else {
    print("No name provided.")
}

// bind to a different name
if let unwrapped = myName {
    print(unwrapped.count)
}

// multiple optionals in one shot
var firstName: String? = "Ammar"
var lastName: String? = "Saber"

if let first = firstName, let last = lastName {
    print("\(first) \(last)")
}

// ========================================================================================

// MARK: 2. guard let

func greet(_ name: String?) {
    guard let name else {
        return // return early if name is nil
    }
    
    // here name is accessible and 100% not nil.
    print("Hello \(name)!")
}

func greet2(_ name: String?) {
    // MARK: if let vs guard let
    
    // if let — unwrapped value lives INSIDE the block only
    if let name = name {
        print(name)
    }
    // name doesn't exist here

    // guard let — unwrapped value lives for the REST OF THE FUNCTION
    guard let name = name else { return }
    
    print(name) // ✓ accessible here
}

// ========================================================================================

// MARK: Nil coalescing `??`
// When you don't need to branch — you just want a real value or a sensible fallback — ?? does it in one expression.

let username: String? = nil
let display = username ?? "Guest"

let num: Int? = nil
let safeNum = score ?? 0

// Chain ?? for a priority list of fallbacks. Swift evaluates left to right and stops at the first non-nil:

let preferredCity: String? = nil
let detectedCity: String? = nil

let city = preferredCity ?? detectedCity ?? "Cairo" // city is now "Cairo" as both previous variables are nil!

// ========================================================================================

// MARK: Optional Chaining `?.`

struct Address { var city: String? }
struct User    { var address: Address? }

let user: User? = User(address: Address(city: "Cairo"))

// Without chaining — deep nesting
if let u = user, let addr = u.address, let city = addr.city {
    print(city.uppercased())
}

// With chaining — same result
let cityUppercased = user?.address?.city?.uppercased()   // String? — nil if any link fails
let cityName = user?.address?.city ?? "Unknown"   // String — never nil


// You can also call methods through a chain:
//user?.sendNotification()    // called only if user != nil, silently skipped otherwise

// ========================================================================================

// MARK: Force unwrapping `!`

let forceName: String? = "Ammar"
print(forceName!.count)    // 5 — fine because name has a value

let empty: String? = nil
//print(empty!.count)   // 💥 Fatal error: unexpectedly found nil while unwrapping

// Force unwrapping isn't wrong by itself — it's a deliberate statement that you know the value is there, and you're willing to crash if you're wrong. The problem is using it out of laziness rather than certainty.

// A useful rule of thumb: if you can't write one sentence explaining why this can never be nil, don't force unwrap it.

// ========================================================================================

// MARK: Implicitly unwrapped optionals `String!`

// Declared with ! instead of ?. They behave like regular optionals internally, but Swift lets you use them without unwrapping — as if they were a plain String. If they're nil when accessed, the app crashes, same as !.

var value: String! = "hello"
print(value.count)   // used directly — no unwrapping needed


// You'll mostly encounter these when working with older Apple APIs or bridging to Objective-C frameworks.

// One subtle behavior — the implicit-unwrap flag is lost when you copy:
let unwrappedName: String! = "Ammar"
let copy = name    // copy is String?, not String!

// ========================================================================================

// MARK: switch and pattern matching with optionals

// Since Optional is just an enum with .some and .none, you can switch on it directly:
func describe(_ score: Int?) {
    
    switch score {
    case .some(let value):
        print("Score: \(value)")
    case .none:
        print("No score yet")
    }
}

// The ? pattern in a switch matches and unwraps non-nil values in one step:
func optionalSwitch() {
    let name: String? = "Ammar"
    let role: String? = nil

    switch (name, role) {
    case let (name?, role?):
        print("\(name) — \(role)")
    case let (name?, nil):
        print("\(name) — no role assigned")
    default:
        print("Unknown user")
    }
}
optionalSwitch()


// Loop over an array of optionals, skipping nil entries automatically:
let names: [String?] = ["Ammar", nil, "Sara", nil, "Ali"]

for case let name? in names {
    print(name)    // prints Ammar, Sara, Ali — nils silently skipped
}

// ========================================================================================

// MARK: Transforming optionals — map and flatMap

// Instead of unwrapping, transforming, then rewrapping — you can transform directly on the optional. If it's nil, the transformation is skipped and nil passes through.

