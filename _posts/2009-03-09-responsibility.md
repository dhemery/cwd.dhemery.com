--- 
title: The Anatomy of a Responsibility
date: 2009/03/09 23:06:33
tags: 
- coding
- design
- testing

---

Because the concept of <strong>system responsibility</strong> is so foundational to how I develop and test software, I want to expand on <a href="/2009/02/planned-response-systems/#responsibility">my earlier description</a>.  Recall that I defined a system responsibility as a system’s obligation to respond to each notification of a specified kind of event under specified circumstances by producing a specified set of planned results.

A system responsibility includes three parts:
<ul>
	<li>A stimulus that triggers the system to respond to an event.</li>
	<li>A context in which the system is required to respond to the stimulus.</li>
	<li>A set of results that the system is obligated to realize in response to that stimulus in that context.
</ul>
<a href="http://picasaweb.google.com/lh/photo/585jMgc2tiDWBEY65nsJLw?feat=embedwebsite"><img src="http://lh5.ggpht.com/_4CAMd3shpKw/SbWRWOSXcVI/AAAAAAAAAn4/lBtxMoUn__A/s400/responsibility.jpg" alt="" /></a>

<strong>Stimulus.</strong> <em>A stimulus is a message, sent by someone or something outside the boundary of the system, that informs the system of an event to which it is obligated to respond.</em> The stimulus has a name, which may identify either the event that it represents or the planned response that the system must carry out.  The stimulus may include additional information about the event.

Stimuli are delivered to a system through its interfaces.  An interface defines a set of messages to which a system responds, and the mechanisms by which those messages are delivered.  For GUI systems, the interface includes a suite of windows, forms, buttons, text fields, and other mechanisms that translate user gestures (mouse clicks, key presses) into messages.  Web-based systems receive stimuli through HTTP requests and other interfaces.  Smaller scale systems, such as objects inside a software application, expose Application Programming Interfaces (APIs) that define the set of methods to which internal objects and subsystems respond.

<strong>Result.</strong> <em>A result is an effect that the system realizes in response to a specified stimulus in a specified context.</em> A result may be either a message delivered to someone or something outside the boundary of the system or a change in the system’s internal state.

GUI systems deliver messages through forms, windows, screens, audio devices, and other output devices.  Web-based systems deliver messages through HTTP responses and requests.  An application's internal objects and subsystems deliver messages through method calls and method return values.

In addition to delivering messages to external entities, systems also respond to events by recording information internally, and by making changes to that internal information.  The information may be stored inside the running application, in a database, in files on the computer's file system, or other storage mechanisms.  The information that a system stores in order to guide its responses to future events makes up the system state.

<strong>Context.</strong> Sometimes a system's planned response depends not just on information delivered through the stimulus, but other information as well.  <em>The context for a given responsibility is all of the information other than that delivered in the stimulus that influences the results that the system is obligated to realize in response to an event.</em> The context may include information about the state of the system itself--that is, information that the system previously recorded in its internal memory about prior events.  The context may also include information that the system can observe across its boundary--information that the system must request from external entities in order to fulfill the responsibility.</ul>
</li>
</ul>
