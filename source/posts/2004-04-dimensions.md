--- 
title: Dimensions of Software Testing
date: 2004/04/29 00:40:00
tags: 
- design
- testing

---

A few days ago I was poking around the web for ideas about how to test software, and I saw Scott Ambler's article about "<a href="http://www.ronin-intl.com/publications/floot.html">Full Life Cycle Object-Oriented Testing (FLOOT)</a>."  The article includes a list of common testing techniques.  As I looked over the list, I noticed that <strong>there is a small set of key dimensions that distinguish one testing technique from another.</strong> For example, unit testing and system testing differ in the kind of component they test. Stress testing and usability testing differ in the quality attribute that they test for. Unit testing and acceptance testing differ in the nature of the decisions that are made based on the test results.

I love looking for patterns like that, so I spent an hour analyzing Scott's to identify the dimensions. Here are thirteen dimensions I found, and a few examples that show how different testing techniques vary along each.


<strong>Unit Under Test.</strong>  What type of component being tested?
<ul>
	<li>In Class Testing or Unit Testing, the unit under test is <em>a class.</em></li>
	<li>In Method Testing, the unit under test is <em>a method of a class.</em></li>
	<li>In System Testing, the unit under test is <em>the system.</em></li>
</ul>
<strong>Test Case Scope.</strong>  What is the scope of the interaction tested by each test case?
<ul>
	<li>In Use-Case Scenario Testing, the scope of the interaction tested by each test case is <em>a user goal.</em></li>
	<li>In Unit Testing, the scope of each test case is <em>a method invocation.</em></li>
	<li>In Integration Testing, the scope is <em>a transaction.</em></li>
</ul>
<strong>Unit Coverage.</strong>  What  subset of the unit under test is exercised by the test suite?
<ul>
	<li>In Coverage Testing, the subset being exercised by the test suite is <em>code statements.</em></li>
	<li>In Path Testing, the coverage is <em>logic paths.</em></li>
	<li>In Regression Testing, the coverage is <em>code changes.</em></li>
	<li>In Boundary-value Testing, the coverage is <em>limits.</em></li>
</ul>
<strong>Behavioral Scope.</strong>  What subset of the unit-under-test's behavior is being tested?
<ul>
	<li>Installation Testing tests the system's <em>installation procedure.</em></li>
	<li>Functional Testing tests the system's <em>business functionality.</em></li>
	<li>Integration Testing tests <em>interactions among subsystems.</em></li>
</ul>
<strong>Unit Relationships.</strong>  What are the relationships among the units whose interactions are being tested?
<ul>
	<li>In Inheritance-regression Testing, the relationship between units is <em>inheritance.</em></li>
	<li>In Integration Testing, the relationship is <em>collaboration</em> or <em>peers.</em></li>
</ul>
<strong>Quality Attribute.</strong>  What type of quality attribute is being tested?
<ul>
	<li>In Stress Testing or Volume Testing, the quality attribute being tested is <em>throughput</em> or <em>latency</em> or <em>capacity.</em></li>
	<li>In Usability Testing, the quality attribute being tested is <em>usability.</em></li>
</ul>
<strong>Stakeholder.</strong>  Whose interests are the focus of the testing?
<ul>
	<li>Acceptance Testing focuses on the interests of <em>users.</em></li>
	<li>Operations Testing focuses on the interests of <em>operators.</em></li>
	<li>Support Testing focuses on the interests of <em>support staff.</em></li>
</ul>
<strong>Liveness.</strong> How closely does the test environment mimic the operational environment. Or perhaps this dimension is better characterized as <em>Safety</em>:  To what extent are the testers using the system to do the real work for which the system was intended?
<ul>
	<li>In a Pilot, the test <em>is the actual operational environment, perhaps limited in scope</em> (e.g. a small subset of users, or for a limited time).</li>
	<li>In Beta Testing, the environment is <em>a fully operation environment, but perhaps used only for non-critical functions.</em></li>
	<li>In Acceptance Testing, the environment is <em>a non-operational similar to the operational environment.</em></li>
	<li>Unit Testing is done in <em>the development environment.</em></li>
</ul>
<strong>Visibility into Unit Under Test.</strong>  To what extent does the tester exploit knowledge about the internals of the unit under test?
<ul>
	<li>In Black-box Testing, the tester exploits <em>no knowledge</em> knowledge of internals of the unit under test.</li>
	<li>In White-box Testing, the tester exploits <em>full knowledge</em> of internals.</li>
	<li>In Grey-box Testing, the tester exploits <em>some knowledge</em> of internals.</li>
</ul>
<strong>Tester.</strong>  What is the relationship of the tester to the software under test?
<ul>
	<li>For Acceptance Testing or User Testing, the tester is <em>a user of the software.</em></li>
	<li>For Unit Testing or Developer Testing, the tester is <em>a developer of the software.</em></li>
</ul>
<strong>Processor.</strong>  What type of "processor" will "executes" the "software" during the tests?
<ul>
	<li>In most kinds of testing, <em>a computer</em> executes the software.</li>
	<li>In Code Inspections and Design Reviews, <em>developers</em> "execute" the software.</li>
	<li>In Prototype Walkthroughs, <em>user</em> "execute" the "software."</li>
</ul>
<strong>Pre-Test Confidence.</strong>  How confident are we about the software <em>before</em> we begin the testing?
<ul>
	<li>Before Alpha Testing, our confidence in the software is <em>lower</em> (compared with Beta Testing).</li>
	<li>Before Beta Testing, our confidence in the software is<em> higher</em> (compared with Alpha Testing).</li>
</ul>
<strong>Decision Scope.</strong>  What kinds of decisions will we make based on the outcome of the test?
<ul>
	<li>For Acceptance Testing, the key decision is <em>shell to release the product.</em></li>
	<li>For Integration Testing, the decision may be <em>whether to begin system testing.</em></li>
	<li>For Unit Testing, the decision is <em>whether the current coding task is complete.</em></li>
</ul>
This list is based on only an hour's work, and on my analysis of only a single list of testing techniques (Scott's), so I don't claim that it is anywhere near complete or correct. It <em>might</em> be useful, though, for people who want to expand their repertoire of testing techniques, or to locate a technique that fits a given purpose or context.

I wonder what would happen if we created a thirteen-dimensional matrix. What parts would of the matrix would be crowded with testing techniques? What parts would be empty?

Thirteen dimensions is more than I can handle.  So <strong>what would happen if we took two or three dimensions at a time and explored all of the values along those dimensions?</strong> Would that be interesting? Would it be useful? Would it help us to identify testing techniques that fit our specific situations? Might we notice holes in the matrix for which we want to invent useful techniques?
