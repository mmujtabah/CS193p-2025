# Lectures 01–02 — CodeBreaker

## What was built
The foundation of CodeBreaker — a code-breaking game where players guess
a sequence of colored pegs and receive match markers showing exact vs inexact matches.

---

## Lecture 01 — Intro to Xcode and SwiftUI

### The Lego Analogy
SwiftUI is introduced through a Lego mental model that carries through the entire course:

| Lego | SwiftUI equivalent |
|------|--------------------|
| Individual brick | Primitive View — `Text`, `Image`, `Circle` |
| Constructed model | Composed View — `ContentView` |
| Instruction manual | Container View — `VStack`, `HStack` |
| Bag of Lego | `@ViewBuilder` collecting multiple views |

### Key Concepts
- Xcode interface — canvas, editor, simulator, file navigator
- Every SwiftUI View is a `struct` conforming to the `View` protocol
- `body` is a computed property returning `some View`
- Swift basics — structs, variables, computed properties

---

## Lecture 02 — View Modifiers and Building CodeBreaker

### View Modifiers
The second major pillar of SwiftUI alongside Views.

- Modifiers are chainable functions that each return a new modified View
- Order matters — `.padding().background()` ≠ `.background().padding()`
- Container Views can pass modifiers down to their children

```swift
Text("Hello")
    .font(.title)           // returns ModifiedContent<Text, Font>
    .foregroundStyle(.red)  // wraps that again
    .padding()              // wraps again — order is meaningful
```

### @ViewBuilder — the Bag of Lego
- Lets a function or `var` return multiple Views listed one after another
- The compiler combines them into a single concrete type (`TupleView`)
- `body` on every SwiftUI View is implicitly `@ViewBuilder`
- Write it explicitly only when making your own multi-view functions

```swift
@ViewBuilder
func markers() -> some View {
    Circle().fill(.green)   // brick 1
    Circle().fill(.yellow)  // brick 2
    Circle().fill(.gray)    // brick 3
}
```

### Why not just return an Array of Views?
Swift arrays require every element to be the same type.
`Text` and `Image` are different types — they can't live in `[View]`
because `View` has associated type requirements. `@ViewBuilder` solves
this by having the compiler build a single concrete `TupleView` type instead.

### Building MatchMarkers
- `enum Match` with `.exact`, `.inexact`, `.nomatch` drives the UI
- `count(where:)` on Array for counting matches functionally
- `.fill()` — solid circle for exact matches
- `.strokeBorder()` — outlined circle for inexact matches
- `.opacity(0)` — hides a slot while preserving grid spacing
- `.aspectRatio(contentMode: .fit)` — keeps circles proportional

### Decomposition
Breaking Views into small focused pieces matters for two reasons:
- Readability and maintainability of code
- The Swift compiler type-checks each piece independently — faster builds

The **helicopter view** pattern: a View created purely to serve `#Preview`,
not used anywhere in the actual app.

---