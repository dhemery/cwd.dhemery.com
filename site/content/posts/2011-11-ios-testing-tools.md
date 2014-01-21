---
title: "Frank(enstein), Victor, Shelley, and Igor: Tools for Testing iOS Applications"
date: 2011/11/10
tags: [test automation, coding]

---

A client wants to write automated tests for their iOS app.
I did a little research to find existing tools,
and decided that I liked Frank.
Frank embeds a small HTTP server
(the Frank server)
into an iOS application that runs in a simulator.
You can write tests
that interact with views in an app
by sending commands to the Frank server.

Another element of Frank is an API for writing tests using Cucumber,
a simple,
popular Ruby-based testing framework.

One thing didn't fit:
My client's test automators know Java,
but they don't know Ruby or Cucumber.
So I wrote a Java driver
(front end)
for Frank,
which I called Victor.
The Victor API is a DSL
similar to ones I've created in other situations,
such as when I wrote a Selenium-based driver
for testing Web applications.

I soon discovered that Frank development was at a point of transition.
The existing Frank server
relied on a third-party library called UIQuery
to identify the views to interact with.
But UIQuery development had gone stale,
so [Pete Hodgson](http://blog.thepete.net)
(the awesome developer behind Frank)
was in the process of writing
a new query engine called Shelley to replace UIQuery.

I was a little nervous
about inviting my clients to begin using a tool
that was in the midst of such a transition.
So I started writing a query engine of my own,
called Igor.
Now,
my own query engine would be in transition,
too,
but at least my clients and I would be in control of it.

As I chatted about Igor on the Frank mailing list,
Pete nudged invited me
to consider creating a query syntax
that looked something like CSS selectors,
to allow people to apply their existing CSS knowledge.

I've spent much of the last few days designing the Igor syntax.
I also implemented a few basic view selectors.
Finally,
I figured out how to convince Frank
to delegate its queries to Igor,
a process that is becoming easier as Pete adjusts Frank
to allow a variety of query engines.

I'm hoping
to have a few more of the most useful selectors implemented
before I return to my client next Monday.
If you want to take a peek,
or follow along,
or give feedback,
here are links to the various technologies:

  - [Frank](http://www.testingwithfrank.com/):
    Pete Hodgson's iOS driver.
  - [Victor](https://github.com/dhemery/victor/wiki):
    My Java front end for Frank.
  - [Igor](https://github.com/dhemery/igor/wiki):
    My query engine for Frank.
  - [Igor syntax](https://github.com/dhemery/igor/wiki/Igor-Query-Language/)
    based on CSS.
