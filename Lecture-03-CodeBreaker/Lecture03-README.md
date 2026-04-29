# Lecture 03 — Swift Type System & Model-UI Separation

## What this lecture covers
A bridge between foundational SwiftUI concepts and building the full
CodeBreaker app. Two major themes: refining SwiftUI implementation details
and understanding Swift's type system from the ground up.

---

## Part 1 — SwiftUI Refinements

### @ViewBuilder vs explicit return
- A function marked `@ViewBuilder` does not use `return` — you just list views
- If a function has a single expression you can omit `return`, but with
  multiple views `@ViewBuilder` is required
- Knowing when each applies removes a common source of compiler errors

### Functional programming with closures
Refining a filter function step by step:

```swift
// named function
matches.count(where: { match in match == .exact })

// trailing closure
matches.count { match in match == .exact }

// shorthand argument
matches.count { $0 == .exact }
```

`$0` refers to the first argument automatically — the most concise form.
All three are equivalent; choose based on readability.

---

## Part 2 — Model-UI Separation

### The core principle
The **Model** is the single source of truth for app logic and data.
It knows nothing about the UI. The **UI** is a visual manifestation of
the Model — it reads from it and reacts to changes in it.

```
Model  ←────────────  UI reads from Model
  ↑                        |
  └──────── @State ─────────┘
            triggers re-render
```

### @State
- Marks a property as a source of truth inside a View
- When a `@State` value changes, SwiftUI automatically re-renders the View
- SwiftUI is **declarative** — you describe what the UI should look like
  for a given state, not how to update it step by step
- SwiftUI is **reactive** — the UI updates itself whenever state changes

---

## Part 3 — Swift Type System

### Structs vs Classes

| | Struct | Class |
|---|---|---|
| Type | Value type | Reference type |
| Copying | Independent copy | Shared reference |
| Mutability | Immutable by default | Mutable |
| Memory | Stack (copy-on-write) | Heap |
| SwiftUI preference | ✓ Preferred | Rarely used |

**Copy-on-write**: Swift only makes an actual copy of a struct when it
is mutated — not when it is assigned. This makes structs memory-efficient
despite being value types.

SwiftUI Views are structs because immutability makes diffing and
re-rendering predictable and fast.

### Enums
More powerful than simple label lists — enums can carry **associated data**:

```swift
enum Match {
    case nomatch
    case exact
    case inexact
}

// with associated data
enum Shape {
    case circle(radius: Double)
    case rectangle(width: Double, height: Double)
}
```

Use `switch` to handle every case — the compiler enforces exhaustiveness:

```swift
switch match {
case .exact:   Circle().fill(.green)
case .inexact: Circle().fill(.yellow)
case .nomatch: Circle().fill(.gray)
}
```

### Generics
Allow functions and types to work with any type without losing type safety:

```swift
// Array is generic — it works with any type
var pegs: Array<Color>    // same as [Color]
var scores: Array<Int>    // same as [Int]
```

The `<T>` syntax means "some type T, to be determined at the call site."
The compiler fills in T and enforces consistency throughout.

### Optionals
Represent a value that might be missing — Swift forces you to handle both cases:

```swift
var color: Color?       // either a Color or nil

// optional binding — safe unwrap
if let color {
    // color is guaranteed non-nil here
}
```

**Failable initializers** return an Optional — they return `nil` if
initialization cannot succeed:

```swift
let number = Int("42")   // Int? — succeeds
let bad    = Int("abc")  // Int? — returns nil
```

### Extensions
Add functionality to any existing type without its source code:

```swift
extension Array {
    func count(where condition: (Element) -> Bool) -> Int {
        self.filter(condition).count
    }
}

// now usable on any Array
matches.count { $0 == .exact }
```

Extensions are how SwiftUI adds View-building capabilities to basic
Swift types — you are not modifying the type, just adding to it.

---

## How these concepts connect to CodeBreaker

| Concept | Where it appears |
|---------|-----------------|
| `@ViewBuilder` | `MatchMarkers.body`, custom preview views |
| `@State` | Game state — current guess, number of attempts |
| Struct | Every SwiftUI View, the game Model |
| Enum + associated data | `Match` — `.exact`, `.inexact`, `.nomatch` |
| Generics | `Array<Match>`, `Array<Color>` |
| Optionals | Safe handling of missing game data |
| Extensions | `count(where:)` on `Array<Match>` |

---

## Key takeaway
Swift's type system is strict by design — immutability by default,
exhaustive switch statements, optionals instead of null crashes. These
constraints feel limiting at first but prevent entire categories of bugs
that are common in other languages.
