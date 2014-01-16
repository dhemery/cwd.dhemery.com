--- 
title: Planned Response Systems
date: 2009/02/19 01:12:14
tags: 
- coding
- design
- testing

---

I first learned about the idea of planned response systems from III, a colleague and friend of mine.  I later read about the idea in depth in McMenamin and Palmer's profound book <em><a href="http://www.amazon.com/exec/obidos/ASIN/0917072308/dalehemery-20">Essential Systems Analysis</a></em>.

The idea of planned response systems is fundamental to how I think about programming and testing.  I'm posting my thoughts here so that I can refer to these terms and ideas in later blog posts.  Until I write those posts, I encourage you to notice what happens when you think about software systems as planned response systems.

A <strong><a id="prs">planned response system</a></strong> is a system that responds in planned ways to events in its environment.

For example, a software system is a planned response system—it responds in planned ways to users’ actions.

In an object-oriented software systems, each object is a planned response system—it responds in planned ways to messages sent by other objects.

Planned response systems produce two general <strong>kinds of results</strong>: They send messages to entities outside of the system boundary, and they make changes to the essential memory of the system.

An <strong><a id="event">event</a></strong> is a significant change in the system’s environment. A change is <strong>significant</strong> to the system if the system is obligated to respond to the change in a planned way.

Events fall into two broad categories: Changes initiated by entities in the system’s environment (e.g. users or other systems), and temporal events caused by the passage of of time.

For example, an ATM is obligated to respond in a planned way to a user’s request to withdraw cash. The user’s request is an event.

A <strong><a id="responsibility">system responsibility</a></strong> is a system’s obligation to respond to each notification of a specified kind of event under specified circumstances by producing a specified set of planned results.

The specification of a system responsibility consists of three parts: A specification of a kind of event, a specification of a set of circumstances, and a specification of the set of planned results that the system is obligated to produce in response to being notified of an event of that kind under those circumstances.

A system becomes <strong>obligated to respond</strong> to an event when a system designer allocates that responsibility to the system.

The <strong><a id="essence">essence</a></strong> of a planned response system is the set of responsibilities allocated to the system, independent of the choice of technology used to implement the system.

The definition a system’s essence makes no mention whatever of technology inside the system, because the system’s essential responsibilities would be the same whether it were implemented using software, magical fairies, a horde of trained monkeys, or my brothers Glenn and Gregg wielding pencils and stacks of index cards.

One way to identify the essence of a system is to indulge in <strong><a id="fpt">The Fantasy of Perfect Technology</a></strong>. Imagine a system implemented using perfect technology. Then ask yourself some questions about the quality attributes of the system.

How fast would it respond? <em>If it were made of perfect technology, of course it would respond instantly, with zero delay.</em> How many users could use it at once? <em>An infinite number of users.</em> How much information could it store? <em>An infinite amount.</em> How often would it break? <em>It would never break.</em> How long does it take to start up? <em>None, because it’s always on and always available.</em> How much energy would it use? <em>It would use no energy; heck, it might even generate energy for free.</em>

The one glaring flaw of perfect technology is that it does not exist. Real-world technology is imperfect. That’s what makes this exercise a fantasy. But it’s a useful fantasy, because it helps us to separate the system’s essential responsibilities from the temporary constraints of current technology.

Note that we apply the Fantasy of Perfect Technology only inside the boundary of the system. Even in our fantasy, the world outside of the system is made of real, imperfect stuff, with which the system will have to interact.

Now apply the fantasy to your own system. What responsibilities would your system have even if you could implement it using perfect technology? That set of responsibilities is your system’s essence.

The <em>essential memory</em> of a system is the set of data that the system must remember in order to fulfill its obligations—that is, in order to respond as planned to future events.

For example, an ATM must remember users’ account balances in order to determine whether to satisfy users’ requests to withdraw money.
