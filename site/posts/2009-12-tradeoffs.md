--- 
category:  Coding
- Testing
date: 2009/12/09 12:15:00
tags: []

title: Tradeoffs
comments: true
published: true
layout: post
---

In a thoughful comment on <a href="http://cwd.dhemery.com/2009/11/wmaat/">my blog post</a> about writing maintainable automated acceptance tests, <a href="http://cwd.dhemery.com/2009/11/wmaat/#comment-18843">Chris Falter suggested</a> a different way to name the variables in my test cases. He mentions that our two naming styles present a tradeoff, and that set me on a long trail of thought.

I'm fascinated by tradeoffs, and I often drive myself nuts making them -- I go back and forth and back and forth and... And at some point, I'll identify the qualities that I'm trying to trade off (expressiveness, test speed, number of places I'd have to change if the code or the requirements change) and move on. Until the next time I visit that file. Then I'll go back and forth and back and forth... I am very good at revisiting decisions, and not so good at sticking with a decision I made in the past -- even minutes in the past.

Chris's suggestion points out that there are two pieces of information we're trying to encode into the name: The idea that passwords have a minimum and maximum valid length, and the specific minimum and maximum (6 and 16 characters). I went with one of those pieces of information, Chris went with the other.

As Chris points out, each style leaves readers to infer something important. With Chris's style, readers must infer what's special about any given length. With my style, readers must infer what specific lengths form the boundaries. Neither style expresses <em>both</em> pieces of information explicitly -- e.g. that the maximum legal length is 16 characters. There's a tradeoff here: Which piece of information to express? And by making that tradeoff differently, each style not only <em>expresses</em> one piece of information, but also <em>emphasizes</em> it. My style emphasizes the idea of minimum and maximum lengths; Chris's style emphasizes the specific lengths themselves.

Also, Chris points out (and I agree) that my style requires readers to count string lengths, a tedious, error-prone chore.

Given all of that: <strong>Which style do you prefer? <em>More importantly: What do you prefer about it?</em></strong>

Sometimes I can easily see how to trade off possibilities. Other times I can't see a clear winner. For those times, I recommend experimenting. Try each possibility. Then pay attention to what happens.

In this case, there's another criterion I can apply: With Chris's tests, the length of each password appears three times: Once implicitly in the password itself, once in the declaration of the variable, and once in the test that references each variable. Expressing that specific datum three times is potentially troublesome: If we increase the maximum length of a password to 20, we'd have to change six places (three places for a max length password, three places for a password that's too long). With my style, we'd have to change only two places: the passwords themselves. The variable names would remain the same.

Though I'm not entirely sure which style emphasizes the more important bit of information, the criterion of "how many places I'd have to change" leaves me preferring the style I used in the article. Chris might still reasonably prefer his style, if the extra expressiveness he perceives is valuable enough to outweigh the extra cost of change.

So far, I still prefer my original variable names to Chris's. And yet his suggestion, his thoughtful explanation of why he prefers it, and especially the contrast it provides with my original tests, make me wonder: Now that we know what we're trading off, can we find a way to eliminate the tradeoff altogether? Is there another style that allows us to express all of the information we want to express, and without increasing the cost of change?

Uncle Bob, <a href="http://blog.objectmentor.com/articles/2009/12/07/writing-maintainable-automated-acceptance-tests">in his video</a>, offers a third style: Instead of conveying information through variable names, express it through comments. His comments express something similar to my variable names: maximumness and minimumness. It would be easy enough to add the information that Chris's variable names express and that mine lack: "16 characters is just short enough" and "6 characters is just long enough". I've unfortunately trained myself to feel queasy whenever I start to type a comment into code. I'm going to have to get over that. Writing a comment is not necessarily evil; it's just a tradeoff.

Contrasting my tests to Uncle Bob's, I notice yet another tradeoff: How to organize tests into suites? I organized my tests around specific validity criteria: One set of tests for character content requirements, another for length requirements. Uncle Bob organized the same tests differently: One set of tests for valid passwords, another for invalid passwords. And each way of organizing requires us to <em>name</em> our groupings, which offers an opportunity to subtly highlight one piece of information or the other. My organization emphasizes that are two classes of validity criteria, content and length. Uncle Bob's emphasizes that passwords may be valid or invalid.

<strong>Which emphasis do you prefer? <em>More importantly: What do you prefer about it?</em></strong>

A few final points about tradeoffs. If you want to get better at making tradeoffs such as these, step one is to notice what tradeoffs you're making. And a great way to do that is to pair with someone. I wrote the tests on my own, and in the article I mentioned the tradeoffs I was aware of making. But I made other tradeoffs implicitly, without noticing I was making them. It was only when Chris and Bob offered alternatives that I noticed I was making those tradeoff at all.

Thanks Chris and Bob for inviting me to explore the tradeoffs I make, and how I make them!
