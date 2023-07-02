---
date: "2021-04-12"
draft: true

---

## Test Domains

**Exemplified Domain.**
The *exemplified domain* is the subset of the function domain exemplified in tests. *Exemplified* is a very, very slippery idea. I may or may not have more to say about this later. I will very likely regret bringing it up.

### The TDD Cycle and Domains

**Write a test.** Writing a test (usually) adds an element from the deficit domain into the exemplified domain.

We sometimes write tests that the code already passes. Sometimes we do this on purpose, to express some fact that the other tests merely imply. Other times we do it by accident, and are surprised when the existing code passes the new tests. So our new member of the exemplified domain came not from the deficit domain, but from the output agreement domain.

**Transform the code.** We write the code that passes the tests by applying a series of transformations. By definition, each transformation moves at least one element from the function domain into the output agreement domain.

**Refactor.** By definition, refactoring does not move among domains. In practice, "refactoring" sometimes changes the deficit or surplus domains.

Narrowing the Method Domain: Another Transformation?

A non-empty surplus domain means that the method accepts values that the function does not. Methods implementations deal with members of the excess domain in a variety of ways:

-   Calculating an incorrect value.
-   Explicit exception:
	Detecting that the value is not in the function domain
	and throwing an exception.
-   Implicit exception:
	Performing an operation that is not valid for the value,
	and letting the operation throw an exception.

Another way of thinking about the surplus domain is that it means the method implements  some function other than the one we are comparing it to. We have implemented a related function over some domain larger than the function's domain.

To reduce the surplus domain, we can either change the definition of the function or reduce the domain of the method.
We often change the definition the function, and we often do that tacitly. We name a method after a function, then declare the method to have a domain larger than that of the function.

### ???

- F - M: Unimplemented.
- M - F: Overdeclared.
- M intersect F, m(x)=f(x): Valid.
- M -   Valid: Deficit.

## Transformations and Domains
A transformation is a tiny change that reduces the size of the union of the disagreement domains.

