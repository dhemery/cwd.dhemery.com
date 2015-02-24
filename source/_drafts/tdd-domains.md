---
title: Domains and the Game of Test-Driven Development
date: 2015-12-11
tags:
-   programming

---

# Three Primary Domains
**Function Domain.**
The *function domain* is the domain over which the function is defined.

**Method Domain.**
The *method domain* is the domain over which the method is defined.
This is the Cartesian product of the method's parameter types any variables of program state or environment state accessed by the method.

**Exemplified Domain.**
The *exemplified domain* is the subset of the function domain exemplified in tests.
*Exemplified* is a slippery idea.
I will very likely regret bringing it up.

# Relationships Among Domains
## Definition Mismatches
The way we define a function and the way we declare a method can lead to interesting relationships between their domains:

**Surplus Domain.**
The *surplus domain* is the subset of the method domain that is not in the function domain.
That is: M-F.
The surplus domain includes every value that the method can represent,
and for which the function is undefined.

For example,
if a method takes an `int` parameter
and the function is defined over positive integers,
the surplus domain includes 0 and all of the negative values
that can be represented by an `int`.

**Deficit Domain.**
The *deficit domain* is
the subset of the function domain that is not in the method domain.
That is: F-M.
The deficit domain
includes every value for which the function is defined,
and that the method cannot represent.

For example,
if a method takes an `int` parameter
and the function is declared over the positive integers,
the deficit domain
includes every integer value larger than the maximum representable `int`.

**Common Domain.**
The *common domain* is the intersection of the method domain and the function domain--the domain over which both the function and the method are defined.

## Implementation Mismatches
The way we implement a method can
lead to interesting relationships between the method domain and the function domain:

**Valid Domain.**
The *valid domain* of a method is that subset of the common domain for which the method result matches the function value.

**Invalid Domain.**
The *invalid domain* of a method is the subset of the common domain for which the method result differs from the value of the function.

# Programming as a Game

## The Goal of the Game
The goal of the programming game is to implement a given function.

 A method *implements* a function if and only if the method domain,
 the function domain,
 and the valid domain all match.
 If they don't match,
 then *the method does not implement the function*.

## The State of the Game
Let's phrase the definition of *implements* in another way:
A method implements a function if and only if the surplus domain,
the deficit domain,
and the invalid domain are all empty.

The *goal of the programming game*
is to **empty the surplus, deficit, and invalid domains.**

As long as any of these domains is has members,
the game remains in progress.

## The Moves of the Game

Let's look at the ways a method may not implement a function:

-   The method domain includes elements not in the function domain.
    The overdeclared domain is not empty.
-   The function domain includes elements not in the valid domain.
    The underclared domain is not empty.
-   The method produces the wrong result for some elements of the method domain.
    The invalid domain is not empty.

Programming proceeds by removing elements from these domains.

### Emptying the Invalid Domain
### Emptying the Surplus Domain
### Emptying the Deficit Domain

Let's look at the ways a method may not implement a function:

-   The method domain includes elements not in the function domain.
    The overdeclared domain is not empty.
-   The function domain includes elements not in the valid domain.
    The underclared domain is not empty.
-   The method produces the wrong result for some elements of the method domain.
    The invalid domain is not empty.

## Emptying

# Programmer Moves
Expand Method Domain.
Constrict Method Domain.
Write Test.
Transform Code.
Refactor.

# Transformations and Domains
A transformation is a tiny change in the method that moves at least one element of the method domain into the effective domain.

## The TDD Cycle and Domains

**Write a test.** Writing a test (usually) adds an element from the deficit domain into the exemplified domain.

We sometimes write tests that the code already passes. Sometimes we do this on purpose, to express some fact that the other tests merely imply. Other times we do it by accident, and are surprised when the existing code passes the new tests. So our new member of the exemplified domain came not from the deficit domain, but from the valid domain.

**Transform the code.** We write the code that passes the tests by applying a series of transformations. By definition, each transformation moves at least one element from the deficit domain into the effective domain.

**Refactor.** By definition, refactoring does not change the valid domain.

Narrowing the Method Domain: Another Transformation?

A non-empty excess domain means that the method accepts values that the function does not. Methods implementations deal with members of the excess domain in a variety of ways:
-   Calculating an incorrect value.
-   Explicit exception: Detecting that the value is not in the function domain and throwing an exception.
-   Implicit exception: Performing an operation that is not valid for the value, and letting the operation throw an exception.
Another way of thinking about the excess domain is that it means the method implements  some function other than the one we are comparing it to. We have implemented a related function over some domain larger than the function's domain.
To reduce the excess domain, we can either change the definition of the function or reduce the domain of the method.
We often change the definition the function, and we often do that tacitly. We name a method after a function, then declare the method to have a domain larger than that of the function.

## ???

-   F - M: Unimplemented.
-   M - F: Overdeclared.
-   M intersect F, m(x)=f(x): Valid.
-   M -   Valid: Deficit.
