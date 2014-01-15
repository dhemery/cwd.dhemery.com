--- 
categories: 
- Coding
date: 2010/12/15 05:26:12
tags: 
- unit testing
- JUnit
title: Using Rules to Influence JUnit Test Execution
comments: true
published: true
layout: post
---

<p>JUnit rules allow you to write code to inspect a test before it is run, modify whether and how to run the test, and inspect and modify test results. I've used rules for several purposes:</p>
<ul>
<li>Before running a test, send the name of the test to Sauce Labs to create captions for SauceTV.</li>
<li>Instruct Swing to run a test headless.</li>
<li>Insert the Selenium session ID into the exception message of a failed test.</li>
</ul>

<h3>Overview of Rules</h3>

<p><strong>Parts.</strong> The JUnit rule mechanism includes three main parts:</p>
<ul>
<li>Statements, which run tests.</li>
<li>Rules, which choose which statements to use to run tests.</li>
<li><code>@Rule</code> annotations, which tell JUnit which rules to apply to your test class.</li>
</ul>

<p><strong>Flow.</strong> To execute each test method, JUnit conceptually follows this flow:</p>
<ol>
<li>Create a default statement to run the test.</li>
<li>Find all of test class's rules by looking for public member fields annotated with <code>@Rule</code>.</li>
<li>Call each rule's <code>apply()</code> method, telling it which test class and method are to be run, and what statement JUnit has gathered so far. <code>apply()</code> decides how to run the test, selects or creates the appropriate statement to run the test, and returns that statement to JUnit. JUNit then passes this statement to the next rule's apply() method, and so on.</li>
<li>Run the test by calling the <code>evaluate()</code> method of the statement returned by the last rule.</li>
</ol>

<p>I'll describe the flow in more detail in the final section, below. Now let's take a closer look at the parts, with an example. (The code snippets are available as <a href="https://gist.github.com/741341">a gist on GitHub</a>.)</p>

<h3>Writing Statements</h3>

<p>A statement executes a test, and optionally does other work before and after executing the test. You write a new statement by extending the abstract <code>Statement</code> class, which declares a single method:</p>
<blockquote><pre>
public abstract void evaluate() throws Throwable;
</pre></blockquote>

<p>A typical <code>evaluate()</code> method acts as a wrapper around another statement. That is, it does something before the test, calls another statement's <code>evaluate()</code> method to execute the test, then does something after the test.</p>

<p>Here is an example of a statement that invokes the base statement to run the test, then takes a screenshot if the test fails:</p>
<blockquote><pre>
public class MyTest {
    @Rule
    public MethodRule screenshot = new ScreenshotOnFailureRule();

    @Test
    public void myTest() { ... }

    ...
}
</pre></blockquote>

<h3>Writing Rules</h3>

<p>A rule chooses which statement JUnit will use to run a test. You write a new rule by implementing the <code>MethodRule</code> interface, which declares a single method:</p>
<blockquote><pre>
Statement apply(Statement base, FrameworkMethod method, Object target);
</pre></blockquote>
<p>The parameters are:</p>
<ul>
<li><code>method</code>: A description of the test method to be invoked.</li>
<li><code>target</code>: The test class instance on which the method will be invoked.</li>
<li><code>base</code>: The statement that JUnit has gathered so far as it applies rules. This may be default statement that JUnit created, or a statement created by another rule.</li>
</ul>

<p>The purpose of <code>apply()</code> is to produce a statement that JUnit will later execute to run the test. A typical <code>apply()</code> method has two steps:</p>
<ol>
<li>Create a statement instance.</li>
<li>Return the newly created statement to JUnit.</li>
</ol>

<p>Note that when JUnit later calls the statement's <code>evaluate()</code> method, it does not pass any information. If the statement needs information about the test method, the test class, how to invoke the test, or anything else, you will need to supply that information to the statement yourself (e.g. via the constructor) before returning from <code>apply()</code>.</p>

<p>Almost always you will pass <code>base</code> to the new statement's constructor, so that the statement can call <code>base</code>'s <code>evaluate()</code> method at the appropriate time. Some statements need information extracted from <code>method</code>, such as the method name or the name of the class on which the method was declared. Others do not need information about the method. It's rare that a statement will need information about <code>target</code>. (The only one I've seen is the default one that JUnit creates to invoke the test method directly.)</p>

<p>Often, there is no decision to make. Simply create the statement and return it, as in this example:</p>
<blockquote><pre>
public class ScreenshotOnFailureRule implements MethodRule {
    @Override
    public Statement apply(Statement base, FrameworkMethod method, Object target) {
        String className = method.getMethod().getDeclaringClass().getSimpleName();
        String methodName = method.getName();
        return new ScreenshotOnFailureStatement(base, className, methodName);
    }
}
</pre></blockquote>

<p>In situations that are not so simple, you can compute the appropriate statement depending on information about the test method. For example, you may wish to suppress screenshots for certain tests, which you indicate the <code>@NoScreenshot</code> annotation. Your screenshot rule can choose the appropriate statement depending on whether the annotation is present on the method:</p>
<blockquote><pre>
public class ScreenshotOnFailureRule implements MethodRule {
    @Override
    public Statement apply(Statement base, FrameworkMethod method, Object target) {
        if(allowsScreenshot(method)) {
            String className = method.getMethod().getDeclaringClass().getSimpleName();
            String methodName = method.getName();
            return new ScreenshotOnFailureStatement(base, className, methodName);
        }
        else {
            return base;
        }
    }

    private boolean allowsScreenshot(FrameworkMethod method) {
        return method.getAnnotation(NoScreenshot.class) == null;
    }
}
</pre></blockquote>

<h4>A note about upcoming changes in the rule API</h4>

<p>In JUnit 4.9&#8212;the next release of JUnit&#8212;the way you declare rules will change slightly. The <code>MethodRule</code> interface will be deprecated, and the <code>TestRule</code> interface added in its place. The signature of the <code>apply()</code> method differs slightly between the two interfaces. As noted above, the signature in the deprecated <code>MethodRule</code> interface was:</p>

<blockquote><pre>
Statement apply(Statement base, FrameworkMethod method, Object target);
</pre></blockquote>

<p>The signature in the new <code>TestRule</code> interface is:</p>

<blockquote><pre>
Statement apply(Statement base, Description description);
</pre></blockquote>

<p>Instead of using a <code>FramewordMethod</code> object to describe the test method, the new interface uses a <code>Description</code> object, which gives access to essentially the same information. The <code>target</code> object (the instance of the test class) is no longer provided.</p>




<h3>Applying Rules</h3>

<p>To use a rule in your test class, you declare a public member field, initialize the field with an instance of your rule class, and annotate the field with <code>@Rule</code>:</p>

<blockquote><pre>
public class MyTest {
    @Rule
    public MethodRule screenshot = new ScreenshotOnFailureRule();

    @Test
    public void myTest() { ... }

    ...
}
</pre></blockquote>

<h3>The Sequence of Events In Detail</h3>

<p>JUnit now applies the rule to every test method in your test class. Here is the sequence of events that occurs for each test (omitting details that aren't related to rules):</p>
<ol>
<li>JUnit creates an instance of your test class.</li>
<li>JUnit creates a default statement whose <code>evaluate()</code> method knows how to call your test method directly.</li>
<li>JUnit inspects the test class to find fields annotated with <code>@Rule</code>, and finds the <code>screenshot</code> field.</li>
<li>JUnit calls <code>screenshot.apply()</code>, passing it the default statement, the instance of the test class, and information about the test method.</li>
<li>The <code>apply()</code> method creates a new <code>ScreenshotOnFailureStatement</code>, passing it the default statement and the names of the test class and test method.</li>
<li>The <code>ScreenshotOnFailure()</code> constructor stashes the default statement, the test class name, and the test method name for use later.</li>
<li>The <code>apply()</code> method returns the newly constructed screenshot statement to JUnit.</li>
<li>(If there were other rules on your test class, JUnit would call the next one, passing it the statement created by your screenshot rule. But in this case, JUnit finds no further rules to apply.)</li>
<li>JUnit calls the screenshot statement's <code>evaluate()</code> method.</li>
<li>The screenshot statement's <code>evaluate()</code> method calls the default statement's <code>evaluate()</code> method.</li>
<li>The default statement's <code>evaluate()</code> method invokes the test method on the test class instance.</li>
<li>(Let's suppose that the test method throws an exception.)</li>
<li>Your screenshot statement's <code>evaluate()</code> method catches the exception, calls the <code>MyScreenshooter</code> class to take the screenshot, and rethrows the caught exception.</li>
<li>JUnit catches the exception and does whatever arcane things it does when tests fail.</li>
</ol>
