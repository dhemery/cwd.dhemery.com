--- 
title: Beware Accounting Errors
date: 2008/12/31 13:06:21
tags: 
- coding
- leading
- TDD

---

Beware accounting errors.

A highly visible part of TDD is that developers write more tests than they used to.  It is tempting to conclude from this that programming takes longer with TDD than without.  After all, we are writing tests that we didn’t write before, and this is additional work on top of all the work we used to do.  Right?

That’s a perfectly reasonable conclusion.  But it is based on a flawed assumption, an accounting error that leads us to overlook some important costs.  The assumption is that in addition to the new work of writing tests, developers will continue to do all of the same work they were doing before.

This assumption turns out to be unwarranted in practice.  For example, before TDD, developers typically spend a great deal of time debugging.  Why are they debugging?  Because they have identified a failure, but they don’t know what specific piece of code is broken that produces the failure.  They step through the code in the debugger in order to trace the failure to the fault.  Only when they identify the broken code can they fix it.

TDD reduces the amount of debugging in two ways.  First, developers write fewer defects.  Second, when a developer introduces a defect, the code immediately fails one or more tests.  These tests point directly toward the broken code.  If the tests tell me what specific code is broken, I don’t need to run the debugger to find the fault.

Also, if developers write fewer defects, they now spend less time fixing defects.

If we add up all of the effects of TDD, including the cost of writing tests and the cost savings we gain by writing tests, we find that the first few features cost slightly more than without TDD, but that the quality is noticeably higher.  And we find that later features take less time than without TDD, because TDD keeps code changeable.

An additional wrinkle leads to another accounting error: not everyone sees debugging as a cost.  In my pre-TDD days, I usually enjoyed debugging.  I loved having a meaty puzzle to solve.  It was often the most fun and interesting and engaging part of programming.  And in one job, my managers (falling prey to yet another accounting error) rewarded <em>fixing</em> bugs far more visibly and vocally than <em>preventing</em> them.

If you're a manager, learn to attend not just to the obvious costs and benefits of a given set of programming practices, but also the costs and benefits that require a little effort and insight to detect.

If you're a developer, I can tell you that I don't miss debugging.  The puzzle of how to choose the next test that will drive my code toward completion is as fun and interesting and challenging as debugging ever was.  I hope it's the same for you.
