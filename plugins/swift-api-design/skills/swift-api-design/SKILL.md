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

## Always-On Behavior

This skill is active whenever Swift code is being written, reviewed, or discussed. You do not wait to be asked. When you see a guideline violation, call it out immediately alongside any other feedback.

If you are explaining code, writing new code, or reviewing existing code, run the checklist below against every declaration in scope.

---

## The Guidelines Checklist

Work through these in order. Every `yes` is a finding.

### Fundamentals

- [ ] Is the API unclear at the point of use (not the point of declaration)?
- [ ] Was brevity chosen over clarity?
- [ ] Is there a declaration missing a documentation comment?
- [ ] Would writing a doc comment reveal a design problem?

### Naming — Promote Clear Usage

- [ ] Is a necessary word missing that would prevent ambiguity? (e.g., `remove(_:)` when both position and value removal are possible)
- [ ] Is a needless word present that just restates the type? (e.g., `removeElement`, `userString`, `colorValue`)
- [ ] Is something named after its type rather than its role? (e.g., `string` instead of `greeting`, `viewType` instead of `ContentView`)
- [ ] Is a weakly-typed parameter (`Any`, `AnyObject`, `Int`, `String`) missing a noun describing its role?

### Naming — Strive for Fluent Usage

- [ ] Does the method name fail to form a natural English phrase at the call site?
- [ ] Does a factory method omit the `make` prefix? (e.g., `iterator()` instead of `makeIterator()`)
- [ ] Does an initializer's first argument form a phrase starting with the base name? (e.g., `Color(havingRed: 32)` instead of `Color(red: 32)`)
- [ ] Does a mutating method fail to read as an imperative verb phrase? (e.g., `sorted()` instead of `sort()`)
- [ ] Does a nonmutating method fail to read as a noun phrase or verb with "ed"/"ing" suffix? (e.g., `sort()` instead of `sorted()`)
- [ ] Does a Boolean property or method fail to read as an assertion? (e.g., `empty` instead of `isEmpty`, `getIntersection` instead of `intersects(_:)`)
- [ ] Does a protocol describing capability omit the `able`/`ible`/`ing` suffix? (e.g., `Serialize` instead of `Serializable`)
- [ ] Does a protocol describing identity use a suffix instead of a noun? (e.g., `Collectable` instead of `Collection`)
- [ ] Do type, property, variable, or constant names fail to read as nouns?

### Naming — Use Terminology Well

- [ ] Is an obscure term used where a common word would do?
- [ ] Is a term of art used with a different meaning than its established definition?
- [ ] Is a non-standard abbreviation used?
- [ ] Does a name break with established precedent from the Swift standard library or domain convention?

### Conventions — General

- [ ] Does a computed property involve significant computation without documentation noting that?
- [ ] Is a free function used where a method would be more appropriate?
- [ ] Does a type or protocol name use lowerCamelCase instead of UpperCamelCase?
- [ ] Does a variable, function, or parameter name use UpperCamelCase instead of lowerCamelCase?
- [ ] Is an acronym inconsistently cased? (e.g., `userSmtpServer` instead of `userSMTPServer`, or `HTTPSRequest` instead of `httpsRequest` in a variable)
- [ ] Do overloaded methods share a base name despite having unrelated meanings?
- [ ] Is return-type overloading used in a way that creates inference ambiguity?

### Parameters

- [ ] Do parameter names obscure rather than clarify the parameter's role in documentation?
- [ ] Is a defaulted parameter missing where a commonly-used value exists?
- [ ] Are parameters with defaults placed before parameters without defaults?

### Argument Labels

- [ ] Is a label present when arguments are indistinguishable and a label adds no information? (e.g., `min(x: number1, y: number2)` instead of `min(number1, number2)`)
- [ ] Does a value-preserving type conversion initializer include a first argument label? (e.g., `Int64(value: someUInt32)` instead of `Int64(someUInt32)`)
- [ ] Does an argument that forms part of a prepositional phrase lack a label? (e.g., `removeBoxes(12)` instead of `removeBoxes(havingLength: 12)`)
- [ ] Does a first argument that forms a grammatical phrase with the base name have a redundant label? (e.g., `view.addSubview(view: y)` instead of `view.addSubview(y)`)
- [ ] Does a first argument that does NOT form a grammatical phrase lack a label? (e.g., `view.dismiss(false)` instead of `view.dismiss(animated: false)`)
- [ ] Does an argument with a default value lack a label?

### Closures and Tuples

- [ ] Are closure parameters in a public API unnamed?
- [ ] Are tuple members in a public API unlabeled?

### Unconstrained Polymorphism

- [ ] Does an `Any`, `AnyObject`, or unconstrained generic overload create an ambiguous overload set?

---

## Finding Format

For each violation, output:

```
**[Guideline]** _Section name from the guidelines_
**Found:** `the problematic code`
**Why:** One sentence on what the guideline says and why this breaks it.
**Rewrite:** `the corrected code`
```

Group findings by declaration when reviewing multiple. Lead with the highest-impact findings (call-site clarity violations before documentation omissions).

## Tone

Direct and specific. You are applying a clear, published standard — not offering an aesthetic opinion. When pushing back on a name or label, root every objection in the guideline. When suggesting a rewrite, explain what it communicates that the original didn't.

If the user pushes back on a finding, engage with the specific guideline: either defend it or acknowledge a legitimate exception. The guidelines themselves note valid cases where rules are bent (e.g., precedent overrides simplicity for `sin(x)`).

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
