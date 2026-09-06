---
name: swift-api-design
description: Apply when writing, reviewing, or designing any Swift code — functions, types, protocols, closures, or local functions at any scope level. Enforces the Swift API Design Guidelines with specific callouts, pushback, and suggested rewrites.
---

# Swift API Design Guidelines Enforcer

Apply the [Swift API Design Guidelines](https://www.swift.org/documentation/api-design-guidelines/) to any Swift code at any scope — public API, internal helpers, local functions, closures. The guidelines apply everywhere Swift is written.

## Hard Rules

1. **Every finding cites the specific guideline.** Not "bad name" — "violates _Omit Needless Words_: `removeElement` should be `remove` since the parameter type already indicates it's an element."
2. **Always suggest a concrete rewrite.** Don't just flag — show the corrected signature or name.
3. **Push back on violations, don't hedge.** "This doesn't follow the guidelines" not "you might consider."
4. **Apply at every scope level.** Local functions, closure parameters, and tuple member labels are not exempt.
5. **Don't enforce language features as guidelines.** Protocol-oriented design, generics architecture, and performance choices are outside scope. Stay on naming, labels, fluency, documentation, and conventions.
6. **Prioritize by impact.** Flag every violation, but lead with the ones that matter most at the call site.
7. **Recognize accepted exceptions.** The guidelines themselves carve out exceptions (precedent for `sin(x)`, `Array` over `List`, fluency degrading after the first two arguments). Don't flag these — acknowledge them if relevant.
8. **Don't flag framework API conventions.** When user code conforms to UIKit, SwiftUI, Combine, or other Apple framework patterns (delegate methods, `body` properties, `@ViewBuilder` closures), those follow the framework's conventions. Only flag the user's own naming choices.

## Behavior

This skill operates in two modes depending on context:

### When writing new code
Apply the guidelines proactively. Produce correct names, labels, and signatures from the start. If you notice yourself about to write something that violates a guideline, fix it before presenting the code. If the user's request implies a name that violates the guidelines, write the correct version and briefly note why.

### When reviewing existing code
Run the checklist against declarations in scope. Present all findings grouped by declaration, highest-impact first. Focus on the user's code — not framework-imposed patterns they can't change.

### Weighing against the user's primary request
When the user asks for a functional change ("add a cache," "fix this crash"), complete their request first using guideline-compliant code. Then call out any *pre-existing* violations in the code you touched, separately, so the functional work isn't blocked by naming feedback.

---

## Guidelines Reference

This is the authoritative reference for all findings. Every rule is derived from the [official guidelines](https://www.swift.org/documentation/api-design-guidelines/).

### Fundamentals

**Clarity at the point of use** is the most important goal. APIs are declared once but used repeatedly — evaluate names in context of the call site, not the declaration.

**Clarity over brevity.** Brevity in Swift comes from the type system, not from minimizing characters.

**Write a documentation comment for every declaration.** If describing the API in simple terms is hard, you may have designed the wrong API. Use Swift's Markdown dialect. Begin with a single sentence fragment ending with a period:

```swift
// GOOD — describes what the method does
/// Inserts `newHead` at the beginning of `self`.
mutating func prepend(_ newHead: Int)

/// Returns a `List` containing `head` followed by the elements of `self`.
func prepending(_ head: Element) -> List

// GOOD — subscripts describe what is accessed
/// Accesses the `index`th element.
subscript(index: Int) -> Element { get set }

// GOOD — initializers describe what is created
/// Creates an instance containing `n` repetitions of `x`.
init(count n: Int, repeatedElement x: Element)
```

### Naming — Promote Clear Usage

**Include all words needed to avoid ambiguity** for a reader at the use site:

```swift
// GOOD — "at" clarifies this is positional removal
employees.remove(at: x)

// BAD — ambiguous: removing the element x, or at position x?
employees.remove(x)
```

**Omit needless words** that merely restate type information:

```swift
// BAD — "Element" restates the parameter type
public mutating func removeElement(_ member: Element) -> Element?
allViews.removeElement(cancelButton)

// GOOD — parameter type already says it's an element
public mutating func remove(_ member: Element) -> Element?
allViews.remove(cancelButton)
```

**Name according to role, not type:**

```swift
// BAD — named after type constraints
var string = "Hello"
protocol ViewController { associatedtype ViewType: View }
func restock(from widgetFactory: WidgetFactory)

// GOOD — named after role
var greeting = "Hello"
protocol ViewController { associatedtype ContentView: View }
func restock(from supplier: WidgetFactory)
```

**Compensate for weak type information.** When a parameter type is `Any`, `AnyObject`, `NSObject`, `Int`, `String`, or another weakly-informative type, precede it with a noun describing its role:

```swift
// BAD — "for keyPath" is vague with String type
func add(_ observer: NSObject, for keyPath: String)
grid.add(self, for: graphics)

// GOOD — role is clear
func addObserver(_ observer: NSObject, forKeyPath path: String)
grid.addObserver(self, forKeyPath: graphics)
```

### Naming — Strive for Fluent Usage

**Method names should form grammatical English phrases** at the call site:

```swift
// GOOD — reads naturally
x.insert(y, at: z)          // "x, insert y at z"
x.subviews(havingColor: y)  // "x's subviews having color y"
x.capitalizingNouns()        // "x, capitalizing nouns"

// BAD — doesn't read as English
x.insert(y, position: z)
x.subviews(color: y)
x.nounCapitalize()
```

**Factory methods begin with `make`:** `x.makeIterator()`.

**Initializer first arguments should not form a phrase starting with the base name:**

```swift
// BAD
let foreground = Color(havingRGBValuesRed: 32, green: 64, andBlue: 128)
let ref = Link(to: destination)

// GOOD
let foreground = Color(red: 32, green: 64, blue: 128)
let ref = Link(target: destination)
```

**Side-effects determine verb/noun form:**
- No side effects → noun phrase: `x.distance(to: y)`, `i.successor()`
- Has side effects → imperative verb: `print(x)`, `x.sort()`, `x.append(y)`

**Mutating/nonmutating pairs — verb-based operations:** imperative for mutating, "ed"/"ing" suffix for nonmutating:

```swift
// Mutating              // Nonmutating
x.sort()                 z = x.sorted()
x.append(y)              z = x.appending(y)
s.stripNewlines()        let t = s.strippingNewlines()  // "ing" when "ed" is ungrammatical
```

**Mutating/nonmutating pairs — noun-based operations:** noun for nonmutating, `form` prefix for mutating:

```swift
// Nonmutating           // Mutating
x = y.union(z)           y.formUnion(z)
j = c.successor(i)       c.formSuccessor(&i)
```

**Booleans read as assertions** about the receiver: `x.isEmpty`, `line1.intersects(line2)`.

**Protocol naming:**
- Describes what something *is* → noun: `Collection`
- Describes a *capability* → `able`/`ible`/`ing` suffix: `Equatable`, `ProgressReporting`

**Types, properties, variables, and constants read as nouns.**

### Naming — Use Terminology Well

**Avoid obscure terms** when a common word conveys meaning equally well.

**Stick to established meaning** — don't surprise experts or confuse beginners who search for the term.

**Avoid abbreviations.** Any abbreviation's meaning should be easily found by web search.

**Embrace precedent.** Use names programmers already know. `Array` not `List`. `sin(x)` despite abbreviating "sine" — because it's universally precedented in math and programming.

### Conventions

**Document O(n) or worse computed properties.** Users assume property access is O(1).

**Prefer methods and properties to free functions.** Free functions only when: (1) no obvious `self`, (2) unconstrained generic, or (3) established domain notation like `sin(x)`.

**Case conventions:**
- Types and protocols: `UpperCamelCase`
- Everything else: `lowerCamelCase`
- Acronyms uniformly cased: `utf8Bytes`, `userSMTPServer`, `isRepresentableAsASCII`

**Overloading:** methods may share a base name when they share basic meaning or operate in distinct domains. Avoid overloading on return type — it creates ambiguity with type inference:

```swift
// BAD — which value() is called?
func value() -> Int? { ... }
func value() -> String? { ... }
```

**Enum cases** use `lowerCamelCase` and read as nouns or noun phrases that describe their value, not their context.

### Parameters

**Parameter names serve documentation.** Choose names that read naturally in doc comments:

```swift
// GOOD — reads well in documentation
func filter(_ predicate: (Element) -> Bool) -> [Element]
mutating func replaceRange(_ subRange: Range<Index>, with newElements: [E])

// BAD — "includedInResult" is awkward; "r" and "with" are unclear
func filter(_ includedInResult: (Element) -> Bool) -> [Element]
mutating func replaceRange(_ r: Range<Index>, with: [E])
```

**Use defaulted parameters** instead of method families when a single commonly-used value exists. Place parameters with defaults toward the end.

### Argument Labels

**Omit labels when arguments can't be usefully distinguished:** `min(number1, number2)`, `zip(sequence1, sequence2)`.

**Value-preserving type conversions omit the first label.** The first argument is the source:

```swift
// Widening — no label
Int64(someUInt32)
String(veryLargeNumber)

// Narrowing — label describes the conversion
UInt32(truncating: someUInt64)
UInt32(saturating: someUInt64)
```

**Prepositional phrase arguments get a label** starting at the preposition. Exception: when two arguments represent one abstraction, begin the label after the preposition:

```swift
// GOOD — label at preposition
x.removeBoxes(havingLength: 12)

// GOOD — single abstraction, label after preposition
a.moveTo(x: b, y: c)
a.fadeFrom(red: b, green: c, blue: d)

// BAD — preposition split across base name and label
a.move(toX: b, y: c)
a.fade(fromRed: b, green: c, blue: d)
```

**Grammatical phrase arguments:** omit the first label when it forms a grammatical phrase with the base name. Include a label when it doesn't:

```swift
// GOOD — grammatical phrase, no label needed
x.addSubview(y)

// GOOD — not a grammatical phrase, label required
view.dismiss(animated: false)
words.split(maxSplits: 12)

// BAD — missing label creates confusion
view.dismiss(false)   // Don't dismiss? Dismiss a Bool?
words.split(12)       // Split the number 12?
```

**Arguments with default values always get labels** — they can be omitted from the call and don't form grammatical phrases.

### Closures and Tuples

**Label tuple members and name closure parameters** in your API:

```swift
// GOOD — closure params named, tuple members labeled
mutating func ensureUniqueStorage(
  minimumCapacity requestedCapacity: Int,
  allocate: (_ byteCount: Int) -> UnsafePointer<Void>
) -> (reallocated: Bool, capacityChanged: Bool)
```

Closure parameter names follow the same conventions as top-level function parameters.

### Unconstrained Polymorphism

**Take extra care** with `Any`, `AnyObject`, and unconstrained generics to avoid ambiguous overload sets:

```swift
// BAD — when Element is Any, is [2,3,4] one element or a sequence?
func append(_ newElement: Element)
func append<S: Sequence>(_ newElements: S) where S.Element == Element

// GOOD — distinct name resolves ambiguity
func append(_ newElement: Element)
func append<S: Sequence>(contentsOf newElements: S) where S.Element == Element
```

---

## Review Checklist

Work through these in order against each declaration. Every `yes` is a finding.

### Fundamentals

- [ ] Is the API unclear at the point of use (not the point of declaration)?
- [ ] Was brevity chosen over clarity?
- [ ] Is there a declaration missing a documentation comment?
- [ ] Would writing a doc comment reveal a design problem?

### Naming — Promote Clear Usage

- [ ] Is a necessary word missing that would prevent ambiguity?
- [ ] Is a needless word present that restates the type?
- [ ] Is something named after its type rather than its role?
- [ ] Is a weakly-typed parameter missing a noun describing its role?

### Naming — Strive for Fluent Usage

- [ ] Does the call site fail to form a natural English phrase?
- [ ] Does a factory method omit the `make` prefix?
- [ ] Does an initializer's first argument form a phrase starting with the base name?
- [ ] Does a mutating method fail to read as an imperative verb phrase?
- [ ] Does a nonmutating method fail to read as a noun phrase or "ed"/"ing" form?
- [ ] Does a Boolean fail to read as an assertion about the receiver?
- [ ] Does a capability protocol omit the `able`/`ible`/`ing` suffix?
- [ ] Does an identity protocol use a suffix instead of a noun?
- [ ] Do type/property/variable/constant names fail to read as nouns?

### Naming — Use Terminology Well

- [ ] Is an obscure term used where a common word would do?
- [ ] Is a term of art used with a different meaning than its established definition?
- [ ] Is a non-standard abbreviation used?
- [ ] Does a name break with precedent from the standard library or domain?

### Conventions

- [ ] Does a computed property with non-O(1) complexity lack documentation noting that?
- [ ] Is a free function used where a method would be more appropriate?
- [ ] Is a type or protocol in lowerCamelCase, or a non-type in UpperCamelCase?
- [ ] Is an acronym inconsistently cased?
- [ ] Do overloaded methods share a base name with unrelated meanings?
- [ ] Is return-type overloading creating inference ambiguity?
- [ ] Does an enum case use UpperCamelCase or fail to read as a noun?

### Parameters

- [ ] Do parameter names obscure their role in documentation?
- [ ] Is a defaulted parameter missing where a commonly-used value exists?
- [ ] Are parameters with defaults placed before parameters without defaults?

### Argument Labels

- [ ] Is a label present when arguments can't be usefully distinguished?
- [ ] Does a value-preserving type conversion include a first argument label?
- [ ] Does a prepositional phrase argument lack a label?
- [ ] Does a grammatical-phrase first argument have a redundant label?
- [ ] Does a non-grammatical first argument lack a label?
- [ ] Does an argument with a default value lack a label?

### Closures and Tuples

- [ ] Are closure parameters unnamed?
- [ ] Are tuple members unlabeled?

### Unconstrained Polymorphism

- [ ] Does an `Any`/`AnyObject`/unconstrained generic overload create ambiguity?

---

## Finding Format

For each violation, output:

```
**[Guideline]** _Section name from the guidelines_
**Found:** `the problematic code`
**Why:** One sentence on what the guideline says and why this breaks it.
**Rewrite:** `the corrected code`
```

### Worked Example

Given this code:

```swift
func removeElement(_ element: Element) -> Element? { ... }
var string = "Hello"
func getData() -> Bool { ... }
```

The findings would be:

**[Omit Needless Words]** _Naming — Promote Clear Usage_
**Found:** `func removeElement(_ element: Element)`
**Why:** "Element" restates information already conveyed by the parameter type. Every word should carry salient meaning at the use site.
**Rewrite:** `func remove(_ element: Element)`

**[Name According to Role]** _Naming — Promote Clear Usage_
**Found:** `var string = "Hello"`
**Why:** The variable is named after its type (`String`) rather than its role. What is this string's purpose?
**Rewrite:** `var greeting = "Hello"`

**[Boolean Assertions]** _Naming — Strive for Fluent Usage_
**Found:** `func getData() -> Bool`
**Why:** Boolean methods should read as assertions about the receiver. `getData()` reads as an action, not an assertion, and "get" implies fetching data rather than returning a Bool.
**Rewrite:** `var hasData: Bool` (if it's a property) or `func containsData() -> Bool` (if computation is involved)

---

Group findings by declaration when reviewing multiple. Lead with highest-impact findings — call-site clarity violations before documentation omissions.

## Tone

Direct and specific. You are applying a clear, published standard — not offering an aesthetic opinion. Root every objection in the guideline. When suggesting a rewrite, explain what it communicates that the original didn't.

If the user pushes back, engage with the specific guideline: defend it with the reasoning from the reference, or acknowledge a legitimate exception. The guidelines themselves note valid cases — precedent overrides abbreviation rules for `sin(x)`, fluency degrades acceptably after the first two arguments, etc.

## Scope

**In scope:**
- Names: types, protocols, functions, methods, properties, variables, constants, parameters, argument labels, closure parameters, tuple members, enum cases
- Documentation comments — presence and quality
- Mutating/nonmutating pairs
- Factory method conventions
- Boolean readability
- Protocol naming
- Casing conventions
- Argument label rules
- Overload clarity

**Out of scope:**
- Protocol-oriented design choices
- Generic constraints and type system architecture
- Performance characteristics
- Memory management patterns
- Framework selection
- Module organization (except where a name leaks the wrong abstraction)
