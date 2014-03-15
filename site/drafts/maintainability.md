---
title: Title
date: 2014/01/xx HH:MM:SS
tags: []

---

_Eliminate duplication_:
I'm keeping this one.

_Name every important idea_:
Retaining this one.
Refining by adding _use good names_.

Or maybe: _Expressively name every important idea_.

_Extract til you drop_
Extract until there is nothing else to extract.

This has the effect of naming every important idea.

_Hide incidental details_.
This happens as a side effect of naming every important idea.

_Put code where it belongs_.
Change to:
_put code where people will look for it_.

So

  - Name every important idea.
  - Eliminate duplication.
  - Put code where you will look for it.

# The importance of expressive names

Naming every important idea
helps you achieve the other two principles.

**Expressive names make duplication more obvious.**
I extract a bit of code and give it a good name.
Then I extract another bit of code and give it a good name.
Then I notice that the names are similar.
If the extracted chunks are the same,
I can eliminate one.
If they are similar,
perhaps I can refactor them to make them even more similar,
then extract the common parts
into something I can parameterize.

**Expressive names guide you when organizing and finding code.**

