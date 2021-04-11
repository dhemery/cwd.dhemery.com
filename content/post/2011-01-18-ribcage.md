---
date: "2011-01-18T15:26:28Z"
tags:
- coding
- towers
title: 'Towers Episode 1: The Reclining Ribcage'
---

<p>As we begin this episode, I’ve just created <a href="https://github.com/dhemery/Towers/commit/252be5b80247ba67f5e04a25ad5ac4b88c0c059a">a fresh repository</a>, and I’m ready to start developing my Towers game.</p>

# The Walking Skeleton

<p>I pick what I think will be a good “walking skeleton” feature, a feature chosen specifically to quickly conjure much of the application structure into existence. I choose this feature: <em>On launch, Towers displays an 8 block x 8 block “city” of black and white towers, each one floor high, arranged in a checkerboard pattern.</em></p>

<p>With this feature in mind, I write the first acceptance test.</p>

# The City is Eight Blocks Square

<p><strong>Acceptance test: <em><a href="https://github.com/dhemery/Towers/blob/7bf3a0496709373f5724e2b7a7dfebdf45b17698/test/acceptance/com/dhemery/towers/application/OnLaunch.java">The city is eight blocks square.</a></em></strong> I try to make the test very expressive, using a “fluent” style of assertions. To support the test, I write a <code><a href="https://github.com/dhemery/Towers/blob/057d4dec5bbce846f2cb666fbd40fda92812c2b6/test/acceptance/com/dhemery/towers/application/fixtures/CityFixture.java">CityFixture</a></code> class to access information about the city through the GUI, and a <code><a href="https://github.com/dhemery/Towers/blob/057d4dec5bbce846f2cb666fbd40fda92812c2b6/test/acceptance/com/dhemery/towers/application/fixtures/CityAssertion.java">CityAssertion</a></code> class to build the fluent assertion DSL. (This may seem overly complex to you. Hold that thought.)</p>

<p>For assertions I use the <a href="http://docs.codehaus.org/display/FEST/Fluent+Assertions+Module">FEST Fluent Assertions Module</a>. I like the fluent style assertions. In particular, I like being able to type a dot after <code>assertThat(someObject)</code>, and having Eclipse pop up a list of things I can assert about the object.</p>

<p>To sense and wiggle stuff through the GUI, I use the <a href="http://docs.codehaus.org/display/FEST/Swing+Module">FEST Swing Module</a>.</p>

<p><strong>Implementation.</strong> To pass this test, I write code directly into <code><a href="https://github.com/dhemery/Towers/blob/7bf3a0496709373f5724e2b7a7dfebdf45b17698/src/com/dhemery/towers/application/Towers.java">Towers</a></code>, the application’s main class.</p>

<p>At this point, Towers has a display (an empty JFrame), which is prepared to display 64 somethings in an 8 x 8 grid. But it doesn’t yet display any somethings. It’s an 8 x 8 ghost city.</p>

# Each City Block Has a One Floor Tower

<p><strong>Acceptance test: <em><a href="https://github.com/dhemery/Towers/blob/ec08ffa0727c1fd314fed881fd1086e8d63227bd/test/acceptance/com/dhemery/towers/application/OnLaunch.java">Each city block has a one floor tower</a>.</em></strong> To extend the test DSL, I add <code><a href="https://github.com/dhemery/Towers/blob/ec08ffa0727c1fd314fed881fd1086e8d63227bd/test/acceptance/com/dhemery/towers/application/fixtures/TowerFixture.java">TowerFixture</a></code> and <code><a href="https://github.com/dhemery/Towers/blob/ec08ffa0727c1fd314fed881fd1086e8d63227bd/test/acceptance/com/dhemery/towers/application/fixtures/TowerAssertion.java">TowerAssertion</a></code> classes. (This DSL stuff may now seem even more complex to you. Hold that thought.)</p>

<p><strong>Implementation.</strong> I make <a href="https://github.com/dhemery/Towers/blob/ec08ffa0727c1fd314fed881fd1086e8d63227bd/src/com/dhemery/towers/application/Towers.java">the main class</a> display a JButton to represent a tower at each grid location. Grid location seems like a coherent, meaningful concept, so I test-drive a class to represent that. I quickly find that I care only about the location’s name, so I name the class <code><a href="https://github.com/dhemery/Towers/blob/ec08ffa0727c1fd314fed881fd1086e8d63227bd/src/com/dhemery/towers/model/Address.java">Address</a></code>. I name each button based on its address, to allow the test fixtures to look up each “tower” by name. Each button displays “1” to represent the height of the tower.</p>

<p>At this point, there is no model code beyond Address. A tower is represented only by the text displayed in a button.</p>

<p><strong>Speculation.</strong> To pass this test I could have used a simple JLabel to display the tower height. My choice of the more complex JButton was entirely speculative. That was very naughty.</p>

<p><strong>More speculation.</strong> I notice that there’s an orphan <code><a href="https://github.com/dhemery/Towers/blob/ec08ffa0727c1fd314fed881fd1086e8d63227bd/src/com/dhemery/towers/model/Tower.java">Tower</a></code> class sitting all alone in the corner of the repo. Though I’m trying to code outside-in here, my natural bias toward coding inside-out must have asserted itself. The class isn’t actually used in my app, which suggests that I wrote it on speculation. It’s interesting that I would do that. I wonder: Is all inside-out coding speculative?</p>

<p><strong>Blind speculation.</strong> I didn’t commit a test for the unused <code>Tower</code> class. I'm sure that means I didn't write one. So I must have coded it not only speculatively, but blindly. Eeep!</p>

<p><strong>Repospectives.</strong> As I step through the commit chain, I see my sins laid out before me. If Saint Peter uses git, I'm fucked. But I wonder: What else might we learn by stepping through our own git repositories?</p>

# Towers Alternate Colors

<p><strong>Acceptance Test: <em><a href="https://github.com/dhemery/Towers/blob/master/test/acceptance/com/dhemery/towers/application/OnLaunch.java">Towers alternate colors</a>.</em></strong> I express this by checking that towers alternate colors down the first column, and that towers alternate colors along each row.</p>

<p><strong>Simplifying the fixtures.</strong> As I write the third test and the fixture code to support it, I become weary of maintaining and extending my lovely DSL. I abandon it in favor of writing indicative mood statements in simpler <code>&lt;object&gt;.&lt;condition&gt;()</code> format. Now I need only one fixture class per domain concept, rather than two (a class to access items through the GUI and class to make assertions).</p>

<p>Though “the city has width eight” doesn’t trip off the tongue as nicely as “the city is eight blocks wide,” it conveys nearly the same information. The only loss is the idea of “blocks.” I’m okay with that.</p>

<p><strong>Implementation.</strong> I make the main class render each button with foreground and background colors based on the button’s location in the grid.</p>

<p><strong>Adding features to the main class.</strong> At this early point in the project I’m implementing features mostly by writing code directly in the main class. I’m nervous about this, but I’m doing it on purpose, deliberately following the style Steve Freeman and Nat Pryce illustrate in <em><a href="http://www.amazon.com/exec/obidos/ASIN/0321503627/dalehemery-20">Growing Object-Oriented Software, Guided by Tests</a></em> (GOOS). For early features, they write the code in the main class. Later, as the code begins to take shape, they notice the coherent concepts emerging in the code, and extract classes to represent those.</p>

<p>When I first read that, I was surprised. My style is to ask, before writing even the smallest chunk of code: To what class will I allocate this responsibility? Then I test-drive that class. Steve and Nat’s style felt wrong somehow. I made note of that.</p>

<p>Around the same time that I first read GOOS, I watched <a href="http://pragprog.com/screencasts/v-kbtdd/test-driven-development">Kent Beck’s illuminating video series about TDD</a>. In those videos, Kent often commented that he was leaving some slight awkwardness in the code until he had a better idea became apparent (I’m paraphrasing from memory here, perhaps egregiously).</p>

<p>So once again a pattern emerges: Someone really smart says something clearly nonsensical. I think, “That makes no sense,” and let it go. Then someone else really smart says something similar. I think, “How the hell does that work?” Eventually, when enough really smart people have said the same stupid thing, I think, “That makes no sense. I’d better try it.” Then I try it, and it makes sense. Immediately thereafter I wonder why it isn’t obvious to everyone.</p>

<p>As I’ve mentioned, my bias is to code inside-out, writing model code first, then connecting it to the outside world. Now aware of my bias, I chose to work against it. I wrote the code directly into the main class. I was still nervous about that. But I’m still alive, so I must have survived it.</p>

<p><strong>Commit.</strong> The first feature finally fully functions. As I commit this code, a tower is still represented only by the color, text, and name of a button. The only model class is <code>Address</code>, a value class with a name tag.</p>

<p>This will change in the next episode when, within seconds of committing this code, I somewhat appease my I MUST ALWAYS ADD CODE IN THE RIGHT PLACE fetish by immediately extracting a new class.</p>

# That Skeleton Won’t Walk

<p>There’s a problem here. Though I’ve implemented the entire walking skeleton feature, and the implementation brings major chunks of the user interface into existence, the feature does not yet compel the system to respond to any events. It therefore does not require the system to do anything or decide anything in response to external events.</p>

<p>In retrospect, I chose a poor candidate for a walking skeleton. For one thing, it doesn’t walk. It just sort of reclines. For another, it’s not a whole skeleton. At best it's a ribcage. A reclining ribcage. So there’s a lesson for me to learn: <em>Choose a walking skeleton that responds to external events.</em></p>

<p>As I wrote this blog post, I searched the web for a definition of “walking skeleton.” Alistair Cockburn <a href="http://alistair.cockburn.us/Walking+skeleton">defines a walking skeleton</a> as “a tiny implementation of the system that performs a small end-to-end function.” If I’d looked that up earlier (or if I'd remembered the definition from when I first saw it years ago), I would likely have chosen a different feature to animate this corpse. Likely something about moving one tower onto another.</p>
