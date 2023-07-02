---
date: "2015-07-28T00:00:00Z"
tags:
- programming
title: Programming by Emptying the Disagreement Domains
---

This post was triggered by my thinking and rethinking and rethinking about Robert Martin's [Transformation Priority Premise](https://blog.8thlight.com/uncle-bob/2013/05/27/TheTransformationPriorityPremise.html) (TPP). I'm not confident that anyone who lives outside my skin will make sense of this or see any relationship whatsoever between this and the TPP.

But here goes.

## Function Domain and Method Domain

Imagine that we're programming some feature, and the feature can be expressed as a mathematical function. It takes inputs from some set (its domain) and maps the each input to a value from some set (its codomain).

Now a definition:

> The **function domain** is the domain over which the function is defined. This is the Cartesian product of the function's inputs.

Further imagine that the feature can be invoked through a single method in code. We may write more than one method to implement the feature, but callers invoke the feature through a single method.

Further imagine that we can think of each invokation of the method
as taking a single input. This "single" input may be made up of the values of multiple parameters and state variables.

Another definition:

> The **method domain** is the domain over which the method is defined. This is the Cartesian product of the method's parameter types and any variables of program state or environment state accessed by the method.

## Done

Our implementation of the feature is done when:

- The method domain exactly matches the function domain.
- For each input, the method and the function yield the same value.

So if any of the following are true, we are not done:

- The function domain has at least one member that is not accepted by the method.
- The method accepts at least one input that is not in the function domain.
- The function domain has at least one member for which the method's outputs differ from the function value.

Let's identify some sets of inputs that together categorize the state of the effort to implement the function.

The way we define a function and the way we declare and implement a method can lead to interesting relationships between their domains. Let's identify the key ways that these domains may agree or disagree.

## Agreement Domains

> The **input agreement domain** is the set of inputs for which both the function and the method are defined. It is the intersection of the function domain and the method domain.

> The **output agreement domain** of a method is the set of inputs for which the method yields the same result as the function. The output agreement domain is necessarily a subset of the input agreement domain.

## Disagreement Domains

The function and the method may mismatch in either the domains for which they are defined or the values that they yield.

> The **surplus domain** is the subset of the method domain that is not in the function domain. The surplus domain includes every value that the method can accept, and for which the function is undefined.

For example, if a method takes an `int` parameter and the function is defined over positive integers, the surplus domain includes 0 and all of the negative values that can be represented by an `int`.

> The **deficit domain** is the subset of the function domain that is not in the method domain. The deficit domain includes every value for which the function is defined, and that the method cannot accept.

For example, if a method takes an `int` parameter and the function is declared over the positive integers, the deficit domain includes every integer value larger than the maximum representable `int`.

> The **output mismatch domain** is the subset of the input agreement domain for which the method result differs from the value of the function.

## Emptying the Disagreement Domains

In a strict sense, a method *implements* a function if and only if the function domain, the method domain, and the output agreement domain are identical. They take the same inputs and produce the same results. The goal of the implementing a function is to bring these three domains into agreement.

Let's flip that. Any disagreement among these three domains means that at least one of the disagreement domains--the surplus domain, the deficit domain, or the output disagreement domain--is non-empty.

Programming proceeds by progressively emptying the disagreement domains. As long as any disagreement domain has members, we're not done.

### Three Programmer Moves

Programming proceeds in a series of moves. There are three types of moves that make progress:

- Reduce the Surplus Domain.
- Reduce the Deficit Domain.
- Reduce the Output Disagreement Domain.

## Reducing the Surplus Domain

Typically we reduce the surplus domain by changing the signature of the method, such as by changing parameters from more generalized types to more specific ones.

For example, we might change a parameter type from `String` to `TelephoneNumber`, or from `int` to `unsigned int`.

We may also reduce the surplus domain by changing our definition of the function to expand its domain to better match the method domain. Sometimes we do this unconsciously.

We may also simply ignore parts of the surplus domain, if we are convinced that no caller will ever supply those inputs, or if we don't care what happens when callers do supply them. Again, we sometimes do this unconsciously.

## Reducing the Deficit Domain

Typically we reduce the deficit domain by changing the signature of the method, such as by changing parameters from restricted types to more inclusive ones.

For example, we might change a parameter type from `int` to `BigInteger`.

We may also reduce the deficit domain by changing our definition of the function to reduce its domain to better match the method domain. Sometimes we do this unconsciously.

## Reducing the Output Disagreement Domain

Typically we reduce the output disagreement domain by changing the body of the method to produce the correct results for inputs where it previously produced incorrect results.

Rarely (I think) we reduce the output disagreement domain by changing the definition of the function to match the output of the method.

## TDD, Transformations, and Disagreement Domains

My hope is that all of this theory might help someone, somewhere to think more clearly and thoroughly about unit tests, either to assess whether their unit tests are sufficient to warrant their desired confidence in the code, or to select which unit test to write to test-drive the next transformation of the code.

I think these three domains are relevant for thinking about each of Uncle Bob's transformations. And I have a vague sense that there's something here that could help illuminate why Uncle Bob's transformation priorities fall into the order they do.

But this is all fuzzy at the moment. So I'll leave that for another day.