---
title: Domains and the Game of Test-Driven Development
date: 2015-12-11
tags: [ programming ]
---

Imagine that we're programming some feature, and the feature can be expressed as a mathematical function. It takes inputs from some set (its domain) and maps the each input to a value from some set (its codomain).

Further imagine that the feature can be invoked through a single method in code. We may write more than one method to implement the feature, but callers invoke the feature through a single method.

Further imagine that we can think of each invokation of the method
as taking a single input. This "single" input may be made up of the values of multiple parameters and state variables.

The feature is complete when:

- The set of inputs accepted by the method exactly matches the domain over which the function is defined.
- For every input, the method and the function yield the same value.

So if any of the following are true, we are not done:

- The function domain has at least one member that is not accepted by the method.
- The method accepts at least one input that is not in the function domain.
- The function domain has at least one member for which the method's outputs differ from the function value.

# Definition Domains

**Function Domain.**
The *function domain* is the domain over which the function is defined.

**Method Domain.**
The *method domain* is the domain over which the method is defined. This is the Cartesian product of the method's parameter types and any variables of program state or environment state accessed by the method.

# Relationships Among Domains
The way we define a function and the way we declare a method can lead to interesting relationships between their domains. Let's identify the key ways that these domains may agree or disagree.

## Agreement Domains

**Input Agreement Domain.**
The *input agreement domain* is the set of inputs for which both the function and the method are defined. It is the intersection of the function domain and the method domain.

**Output Agreement Domain.**
The *output agreement domain* of a method is the set of inputs for which the method yields the same result as the function. The output agreement domain is necessarily a subset of the input agreement domain.

## Disagreement Domains

The function and the method may mismatch in either the inputs for which they are defined or the values that they yield.

**Surplus Domain.**
The *surplus domain* is the subset of the method domain that is not in the function domain. That is: M-F. The surplus domain includes every value that the method can accept, and for which the function is undefined.

For example, if a method takes an `int` parameter and the function is defined over positive integers, the surplus domain includes 0 and all of the negative values that can be represented by an `int`.

**Deficit Domain.**
The *deficit domain* is the subset of the function domain that is not in the method domain. That is: F-M. The deficit domain includes every value for which the function is defined, and that the method cannot accept.

For example, if a method takes an `int` parameter and the function is declared over the positive integers, the deficit domain includes every integer value larger than the maximum representable `int`.

**Output Mismatch Domain.**
The *output mismatch domain* of a method is the subset of the input agreement domain for which the method result differs from the value of the function.

# Test Domains

**Exemplified Domain.**
The *exemplified domain* is the subset of the function domain exemplified in tests. *Exemplified* is a very, very slippery idea. I will very likely regret bringing it up.

# Programming as a Game

## The Goal of the Game

A method *implements* a function if and only if the function domain and the output agreement domain are identical.

The goal of the programming game is to make the output agreement domain match the function domain.

If the function domain and output agreement domain are not identical, then necessarily at least one of the disagreement domains (the surplus domain, the deficit domain, and the output disagreement domain) must be non-empty.

So the goal of the game is to empty the disagreement domains.

## The State of the Game

The state of the game is the state of the three disagreement domains. As long as any disagreement domain has members, the game remains in progress.

## The Moves of the Game

A move in the programming game is any change that reduces the size of the union of the disagreement domains.

# Programmer Moves

- Expand Method Domain.
- Constrict Method Domain.
- Write Test.
- Transform Code.
- Refactor.

# Transformations and Domains
A transformation is a tiny change that reduces the size of the union of the disagreement domains.

## The TDD Cycle and Domains

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

## ???

- F - M: Unimplemented.
- M - F: Overdeclared.
- M intersect F, m(x)=f(x): Valid.
- M -   Valid: Deficit.
