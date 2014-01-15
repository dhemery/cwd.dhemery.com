--- 
categories: 
- Coding
date: 2011/01/04 14:20:41
tags: 
- unit testing
- JUnit
title: What JUnit Rules are Good For
comments: true
published: true
layout: post
---

<p>In <a href="http://cwd.dhemery.com/2010/12/junit-rules/">my previous post, I described how to write JUnit rules</a>. In this post, I'll describe some of the things rules are good for, with examples.</p>

<p>Before JUnit runs a test, it knows something about the test. When the test ends, JUnit knows something about the results. Sometimes we want test code to have access to that knowledge, or even to alter details about a test, the results, or the context in which the test runs.</p>

<p>Older versions of JUnit offered no easy way for test code to do those things. Neither test class constructors nor test methods were allowed to take parameters. Each test ran in a hermetically sealed capsule. There was no simple API to access or modify JUnit's internal knowledge about a test.</p>

<p>That's what rules are for. JUnit rules allow us to:</p>
<ul>
<li>Add information to test results.</li>
<li>Access information about a test before it is run.</li>
<li>Modify a test before running it.</li>
<li>Modify test results.</li>
</ul>




<h3>Adding Information to Test Results</h3>

<p>A few months ago I was working with testers at a client, automating web application tests using Selenium RC. The tests ran under Hudson on our continuous integration servers. The Selenium server ran in the cloud using Sauce Labs' <a href="http://saucelabs.com/ondemand">Sauce On Demand</a> service.</p>

<p>Information about each test run was available in two places. First, Hudson creates a web page for each test run, including a printout of any exception raised by the test. Second, Sauce On Demand creates a job for each test run, and a web page for each job, which displays a log of every Selenium command and its result, links to screenshots taken just before each Selenium command that would change the state of the browser, and a video of the entire session.</p>

<p>To make it easier to find information about test failures, we wanted a way to link from the Hudson test report to the Sauce Labs job report. Determining the URL to the Sauce Labs job report was easy; our test framework knew how to do that. But we didn't know how to insert the URL into the Hudson test report.  Given that we needed to display the URL only when a test failed, we decided that the easiest solution was to somehow catch every exception, and wrap it in a new exception whose message included the URL. When Hudson printed the exception, the printout would display the URL.</p>

<p>The challenge was: How to catch every exception? For the exceptions thrown directly by our own test code, wrapping them was easy. But what to do about exceptions thrown elsewhere, such as by Selenium? Sure, we could wrap every Selenium call in a try/catch block, but that seemed troublesome.</p>

<p>One possibility seemed promising: Given that every exception eventually passed through JUnit, perhaps we could somehow hook into JUnit, and wrap the exception there. But how to hook into JUnit?</p>

<p>I tweeted about the problem. Kent Beck replied, telling me that my problem was just the thing Rules were designed to help with. He also sent me some nice examples of how write a rule and (of course) how to test it.</p>

<p>With Kent's helpful advice and examples in hand, I was able to quickly write a rule that did exactly what my client and I needed:</p>

<blockquote><pre>
public class ExceptionWrapperRule implements MethodRule {
    public Statement apply(final Statement base, FrameworkMethod method, Object target) {
        return new Statement() {
            public void evaluate() throws Throwable {
                try {
                    base.evaluate();
                } catch (Throwable cause) {
                    throw new SessionLinkReporter(cause);
                }
            }
        };
    }
}
</pre></blockquote>

<p>In our test code, at the point where we establish the Selenium session, we obtain the session ID from Selenium and stash it. If the test fails, the <code>ExceptionWrapperRule</code>'s statement catches it and wraps it in a SeleniumLinkReporter (an Exception subclass we defined). The SeleniumLinkReporter constructor retrieves the stashed session ID, builds the Sauce On Demand job report link, and stuffs it into its exception message.</p>

<p>So this is an example of the first major use of rules: To modify test results by adding information obtained during the test.</p>




<h3>Accessing Information About a Test Before It Is Run</h3>

<p>At that same client, we learned of a new Sauce On Demand feature that we wanted to use: <a href="http://saucelabs.com/blog/index.php/2010/08/sauce-tv-screencast-watch-your-tests-run-live-in-the-cloud/">SauceTV</a>. SauceTV displays a video of the browser while your test is running. As we wrote new tests, changed the features of the web application, and accessed new features of Sauce On Demand, we found ourselves often wanting to watch tests as the executed.</p>

<p>Sauce Labs provides a web page that displays two lists of open jobs for your account: Your jobs that are currently running, and your jobs that are queued to run. To access the video for a test in progress, you click the name of the appropriate job.</p>

<p>By default, each job's name is its Selenium session ID, a long string of hexadecimal digits. Even if you know the session ID, it is difficult to quickly distinguish one long hexadecimal string from another. To help with this, Sauce Labs allows you to assign each job a descriptive name to display in the job lists. You do this by sending a particular command to its Selenium server.</p>

<p>Given that we were running one test per job, the obvious choice for the job name is the name of the test. But how to access the name of the test? Certainly we could add a line like this to each test:</p>

<blockquote><pre>
@Test public void myTest() {
    sendSauceJobName("myTest");
}
</pre></blockquote>

<p>But that's crazy talk. Much better would be a way to detect the test name at runtime, in a single place in the code. How to detect the test name? Rules to the rescue. We wrote this rule:</p>

<blockquote><pre>
public class TestNameSniffer implements MethodRule {
    private String testName;

    public Statement apply(Statement statement, FrameworkMethod method, Object target) {
        String className = method.getMethod().getDeclaringClass().getSimpleName();
        String methodName = method.getName();
        testName = String.format("%s.%s()", className, methodName);
        return statement;
    }
    
    public String testName() {
        return testName;
    }
}
</pre></blockquote>

<p>The rule stashes the test name, and other code later sends the name to Selenium RC. Now Sauce Labs labels each job with the name of the test, which is much easier to recognize than hexadecimal strings.</p>




<h3>Modifying a Test Before Running It</h3>

<p>In a Twitter conversation about what rules are good for, <a href="http://twitter.com/natpryce/status/14970733117579264">Nat Price said</a>, "JMock uses a rule to perform the verify step after the test but before tear-down." JMock is a framework that makes it easy to create controllable collaborators for the code you're testing, and to observe whether your code interacts with them in the ways you intend.</p>

<p>To <a href="http://www.jmock.org/">use JMock in your test code</a>, you declare a field that is an instance of the JUnitRuleMockery class:</p>
<blockquote><pre>
public class MyTestClass {
    @Rule
    public JUnitRuleMockery context = new JUnitRuleMockery();
    
    @Mock
    public ACollaboratorClass aCollaborator;
    
    @Test
    public void myTest() {
        ... // Declare expectations for aCollaborator.
        ... // Invoke the method being tested.
    }
}
</pre></blockquote>

<p>JUnitRuleMockery is a rule whose <code>apply()</code> looks like this:</p>

<blockquote><pre>
@Override
public Statement apply(final Statement base, FrameworkMethod method, final Object target) {
    return new Statement() {
        @Override
        public void evaluate() throws Throwable {
            prepare(target);
            base.evaluate();
            assertIsSatisfied();
        }
        
        ... // Declarations of prepare() and assertIsSatisfied()
    }
}
</pre></blockquote>

<p>Before the statement executes the test, it first calls <code>prepare()</code>, which initializes each mock collaborator field declared by the test class. For the example test class, <code>prepare()</code> initializes <code>aCollaborator</code> with a mock instance of <code>ACollaboratorClass</code>.</p>

<p>Initializing fields in the target is an example of a second use for rules: Modifying a test before running it.</p>





<h3>Modifying Test Results</h3>

<p>The JMock code also demonstrates another use for JUnit rules: Modifying test results. After the test method runs, the <code>assertIsSatisfied()</code> method evaluates whether the expectations expressed by the test method are satisfied and throws an exception if they are not. Even if no exception was thrown during the test method itself, the rule might throw an exception, thereby changing a test from passed to failed.</p>
