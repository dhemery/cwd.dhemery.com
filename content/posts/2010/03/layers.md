---
date: "2010-03-15T17:16:15Z"
tags:
- acceptance testing
- automation
- coding
- design
- essence
- naming
- robot framework
- test automation
title: Four Layers in Automated Tests
---

<p>I’ve known for a while that when I automate tests, layers emerge in the automation. Each chunk of automation code relies on lower-level chunks. In <a href="http://code.google.com/p/robotframework/">Robot Framework</a>, for example, tests invoke “keywords” that themselves invoke lower-level keywords.</p>

<p>The layering <em>per se</em> wasn’t a surprise, because automated tests are software, and software tends to organize into layers. But lately I’ve noticed a pattern. The layers in my automated tests center around four themes:</p>

<ul>
<li>Test intentions</li>
<li>System responsibilities</li>
<li>Essential system interface</li>
<li>System implementation interface</li>
</ul>

<p><strong>Test intentions.</strong> Test names and suite names are the top layer in my automation. If I’ve named each test and suite well, the names express my test intentions. Reading through the test names, and seeing how they’re organized into suites, will give useful information about what I tested and why.</p>

<p>For example, in my article on <a href="http://dhemery.com/pdf/writing_maintainable_automated_acceptance_tests.pdf">“Writing Maintainable Automated Acceptance Tests” (PDF)</a>, I was writing tests for a system’s account creation feature, and specifically for the account creation’s responsibility to validate passwords. I ended up with these test names (see Listing 7):</p>

<ul>
<li>Rejects passwords that omit required character types</li>
<li>Rejects passwords with bad lengths</li>
<li>Accepts minimum and maximum length passwords</li>
</ul>

<p>In <a href="http://blog.objectmentor.com/articles/2009/12/07/writing-maintainable-automated-acceptance-tests">an excellent video followup</a> to my article, Bob Martin organized his tests differently, using <a href="http://fitnesse.org/">FitNesse</a>. He grouped tests into two well-named suites, “Valid passwords” and “Invalid passwords.” Each suite includes a number of relevant example passwords, each described with a comment that expresses what makes the example interesting.</p>

<p>Every test tool that I’ve used offers at least one excellent way to express the intentions of each test. However expressed, those intentions become the top layer of my automated tests.</p>

<p><strong>System responsibilities.</strong> A core reason for testing is to learn whether the system meets its responsibilities. As I refine my automation, refactoring it to express my intentions with precision, I end up naming specific system responsibilities directly.</p>

<p>In my article, I’m testing a specific pair of responsibilities: The account creation command must accept valid passwords and reject invalid ones. As I refactored the duplication out of my initial awkward tests, these responsibilities emerged clearly, expressed in the names of two new keywords: Accepts Password and Rejects Password. Listing 7 shows how my top-level tests build on these two keywords.</p>

<p><strong>Essential system interface.</strong> By system interface, I mean the set of messages that the system sends and receives, whether initiated by users (e.g. commands sent to the system) or by the system (e.g. notifications sent to users).</p>

<p>By essential I mean independent of the technology used to implement the system. For example, the account creation feature must offer some way for a user to command the system to create an account, and it must include some way for the system to notify the user of the result of the command. This is true regardless of whether the system is implemented as a command line app, a web app, or a GUI app.</p>

<p>As I write and refine automated tests, I end up naming each of these essential messages somewhere in my code. In my article, Listing 2 defines two keywords. “Create Account” clearly identifies one message in the essential system interface. Though the other keyword, “Status Should Be,” is slightly less clear, it still suggests that the system emits a status in response to a command to create an account. (Perhaps there’s a better name that I haven’t thought of yet.) Listing 4 shows how the higher-level system responsibility keywords build upon these essential system interface keywords.</p>

<p><strong>System implementation interface.</strong> The bottom layer (from the point of view of automating tests) is the system implementation interface. This is the interface through which our tests interact most directly with the system. Sometimes this interaction is direct, e.g. when Java code in our low-level test fixtures invoke Java methods in the system under test. Other times the interaction is indirect, through an intermediary tool, e.g. when we use <a href="http://seleniumhq.org/">Selenium</a> to interact with a web app or <a href="http://easytesting.org/swing/wiki/pmwiki.php">FEST-Swing</a> to interact with a Java Swing app.</p>

<p>In my article, I tested two different implementations of the account creation feature. The first was a command line application, which the tests invoked through the “Run” keyword, an intermediary built into Robot Framework. Listing 2 shows how the Create Account keyword builds on top of the Run keyword (though you’ll have to parse through the syntax junk to find it).</p>

<p>The second implementation was a web app, which the tests invoked through <a href="http://code.google.com/p/robotframework-seleniumlibrary/">Robot Framework’s Selenium Library</a>, an intermediary which itself interacts through Selenium, yet another intermediary. Listing 8 shows how the revised Create Account keyword builds on various keywords in the Selenium Library.</p>

<strong>Translating Between Layers</strong>

<p>Each chunk of test automation code translates an idea from one layer to the next lower layer. Listing 7 shows test ideas invoking system responsibilities. Listing  4 shows responsibilities invoking messages in the essential system interface. Listings 2 and 8 show how the essential system interface invokes two different system implementation interfaces.</p>

<p>Each of the acceptance test tools I use allows you to build layers like this. In FitNesse, top-level tests expressed in test tables may invoke “scenarios,” which are themselves written in FitNesse tables. And scenarios may invoke lower-level scenarios. In <a href="http://cukes.info/">Cucumber</a>, top-level “scenarios” invoke “test steps,” which may themselves invoke lower-level test steps. In <a href="http://www.thoughtworks-studios.com/agile-test-automation">Twist</a>, “test scenarios” invoke lower-level “concepts” and “contexts.” Each tool offers ways to build higher layers on top of lower layers, which build upon yet lower layers, until we reach the layer that interacts directly with the system we’re testing.</p>

<p>In the examples in my article, I chose to write all of my code in Robot Framework’s keyword-based test language. I defined each keyword entirely in terms of lower-level keywords. I could have chosen otherwise. At any layer, I could have translated from the keyword-based language to a more general purpose programming language such as Java, Ruby, or Python. The other tools I use offer a similar choice.</p>

<p>But I, like many users, find these tools’ test languages easier for non-technical people to understand, and sufficiently flexible to allow users to write tests in a variety of ways. In general, I want as many of these layers as possible to be meaningful not just to technical people, but to anyone who has knowledge of the application domain. So I like to stay with the tool’s test language for all of these layers, switching to a general purpose programming language only at the lowest layer, and then only when the system’s implementation interface forces me to.</p>

<strong>A Lens, Not a Straightjacket</strong>

<p>When I write automated tests for more complex applications, there are often more layers than these. Yet these four jump out at me, perhaps because each represents a layer of meaning that I always care about. Every automated test suite involves test ideas, system responsibilities, the essential system interface, and the system’s implementation interface. Though other layers arise, I haven’t yet identified additional layers that are so universally meaningful to me.</p>

<p>These layers were a discovery for me. They offer an interesting way to look at my test code to see whether I’ve expressed important ideas directly and clearly. I don’t see them as a standard to apply, or a procrustean template to wedge my tests into. They are a useful lens.</p>
