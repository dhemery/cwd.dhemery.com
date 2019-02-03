---
title: Page Object Puzzle
date: 2012/02/24
tags: [test automation, coding]
---

Now that I have a few months of experience
using page objects in my automated tests,
I have a puzzle.

If I understand the page object pattern correctly,
page objects have two kinds of methods:
queries and commands.
A query returns the queried value (of course).
Every command returns a page object,
so that test ideas can be expressed using method chaining.
If the command leaves the browser displaying the same page,
the command returns the current page object.
So far,
all of this makes sense to me.

My puzzle is about what happens
if the command causes the browser to display a new page.
In that case,
the command returns a new page object
that represents the newly displayed page.
The advantage of this
is that it allows reasonably expressive method chaining.
The disadvantage
(it seems to me)
is that it requires each page object knowledge of other pages.
That is,
it makes each page object class
aware of every other page object class
that might be reached via its commands.
And if the result of a command depends on prior existing conditions,
or on validation of inputs,
then each page object command
(in order to return the right kind of page object)
must account for all of the different possible results.

This seems to me
to create an unwieldy tangle of dependencies
from one page object class to another.
How do other people deal with this entanglement?

I'm toying with the idea of adjusting the usual page object pattern:

 1. A query returns the queried value.
 2. If a command _always_ leaves the browser displaying the same page,
    the command returns the current page object.
 3. If a command might lead to a different page,
    the command returns void,
    and the caller can figure out what page object to create
    based on its knowledge of what it's testing.
