--- 
category: 
- Coding
- Testing
date: 2005/04/14 17:40:00
tags: 
- unit testing
title: Test Classes in Isolation and in Collaboration
comments: true
published: true
layout: post
---

When I'm talking to programmers about writing tests for their own code, one of the questions that comes up often is:  <em>Should we test classes in isolation from each other, or in collaboration with each other?</em>

I like both kinds of tests.  Here's why.

I like tests that isolate classes. When a failure occurs, the tests tell me specifically what class failed, and what method failed. That guides me more directly to the fault—the specific code that is broken—and saves a ton of debugging.

I like tests that exercise collaborations.  When a failure occurs, the tests tell me that:
<ul>
	<li>one class or the other is not fulfilling its responsibilities, or</li>
	<li>the collaborators disagree about each other's responsibilities, or</li>
	<li>some other class (the "electrician" class that connects the collaborators with each other) has wired the collaborators together improperly.</li>
</ul>
If the individual classes are well tested, I can focus my collaboration testing specifically on wiring and agreements. And if the individual classes are tested well, collaboration test failures tell me about disagreements and improper wiring.

<strong>When I test classes in isolation, failures guide me quickly to faults.</strong>

<strong>When I test classes in collaboration, failures tell me where the classes disagree about each other's responsibilities.</strong>

So I write both kinds of tests.
