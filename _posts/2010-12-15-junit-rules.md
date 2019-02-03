--- 
title: Using Rules to Influence JUnit Test Execution
date: 2010/12/15 05:26:12
tags: 
- coding
- unit testing
- JUnit

---

JUnit rules allow you to write code to inspect a test before it is run,
modify whether and how to run the test,
and inspect and modify test results.
I've used rules for several purposes:

 - Before running a test, send the name of the test to Sauce Labs to create captions for SauceTV.
 - Instruct Swing to run a test headless.
 - Insert the Selenium session ID into the exception message of a failed test.

# Overview of Rules

**Parts.**
The JUnit rule mechanism includes three main parts:

 - Statements,
   which run tests.
 - Rules,
   which choose which statements to use to run tests.
 - `@Rule` annotations,
    which tell JUnit which rules to apply to your test class.

**Flow.**
To execute each test method,
JUnit conceptually follows this flow:

 1. Create a default statement to run the test.
 1. Find all of test class's rules
    by looking for public member fields annotated with `@Rule`.
 1. Call each rule's `apply()` method,
    telling it which test class and method are to be run,
    and what statement JUnit has gathered so far.
    `apply()` decides how to run the test,
    selects or creates the appropriate statement to run the test,
    and returns that statement to JUnit.
    JUNit then passes this statement to the next rule's apply() method,
    and so on.
 1. Run the test by calling the `evaluate()` method
    of the statement returned by the last rule.

I'll describe the flow in more detail in the final section,
below.
Now let's take a closer look at the parts,
with an example.
(The code snippets are available as
[a gist on GitHub](https://gist.github.com/741341).

# Writing Statements

A statement executes a test,
and optionally does other work before and after executing the test.
You write a new statement by extending the abstract `Statement` class,
which declares a single method:

~~~ java
public abstract void evaluate() throws Throwable;
~~~

A typical `evaluate()` method
acts as a wrapper around another statement.
That is,
it does something before the test,
calls another statement's `evaluate()` method to execute the test,
then does something after the test.

Here is an example of a statement
that invokes the base statement to run the test,
then takes a screenshot if the test fails:

~~~ java
public class MyTest {
  @Rule
  public MethodRule screenshot = new ScreenshotOnFailureRule();

  @Test
  public void myTest() { ... }

  ...
}
~~~

# Writing Rules

A rule chooses which statement JUnit will use to run a test.
You write a new rule by implementing the `MethodRule` interface,
which declares a single method:

~~~ java
Statement apply(Statement base, FrameworkMethod method, Object target);
~~~

The parameters are:

 - `method`:
    A description of the test method to be invoked.
 - `target`:
    The test class instance on which the method will be invoked.
 - `base`:
    The statement that JUnit has gathered so far as it applies rules.
    This may be default statement that JUnit created,
    or a statement created by another rule.

The purpose of `apply()`
is to produce a statement
that JUnit will later execute to run the test.
A typical `apply()` method has two steps:

 1. Create a statement instance.
 1. Return the newly created statement to JUnit.

Note that when JUnit later calls the statement's `evaluate()` method,
it does not pass any information.
If the statement needs information about the test method,
the test class,
how to invoke the test,
or anything else, you will need to supply that information
to the statement yourself
(e.g. via the constructor)
before returning from `apply()`.

Almost always you will pass `base` to the new statement's constructor,
so that the statement can call `base`'s `evaluate()` method
at the appropriate time.
Some statements need information extracted from `method`,
such as the method name or the name of the class
on which the method was declared.
Others do not need information about the method.
It's rare that a statement will need information about `target`.
(The only one I've seen is the default one
that JUnit creates to invoke the test method directly.)

Often,
there is no decision to make.
Simply create the statement and return it,
as in this example:

~~~ java
public class ScreenshotOnFailureRule implements MethodRule {
  @Override
  public Statement apply(Statement base,
                         FrameworkMethod method,
                         Object target) {
      String className = method.getMethod()
                               .getDeclaringClass()
                               .getSimpleName();
      String methodName = method.getName();
      return new ScreenshotOnFailureStatement(base,
                                              className,
                                              methodName);
  }
}
~~~


In situations that are not so simple,
you can compute the appropriate statement
depending on information about the test method.
For example,
you may wish to suppress screenshots for certain tests,
which you indicate the `@NoScreenshot` annotation.
Your screenshot rule can choose the appropriate statement
depending on whether the annotation is present on the method:

~~~ java
public class ScreenshotOnFailureRule implements MethodRule {
  @Override
  public Statement apply(Statement base,
                         FrameworkMethod method,
                         Object target) {
    if(allowsScreenshot(method)) {
      String className = method.getMethod()
                               .getDeclaringClass()
                               .getSimpleName();
      String methodName = method.getName();
      return new ScreenshotOnFailureStatement(base,
                                              className,
                                              methodName);
    }
    else {
      return base;
    }
  }

  private boolean allowsScreenshot(FrameworkMethod method) {
      return method.getAnnotation(NoScreenshot.class) == null;
  }
}
~~~


## A note about upcoming changes in the rule API

In JUnit 4.9
--- the next release of JUnit ---
the way you declare rules will change slightly.
The `MethodRule` interface will be deprecated,
and the `TestRule` interface added in its place.
The signature of the `apply()` method
differs slightly between the two interfaces.
As noted above,
the signature in the deprecated `MethodRule` interface was:

~~~ java
Statement apply(Statement base, FrameworkMethod method, Object target);
~~~

The signature in the new `TestRule` interface is:

~~~ java
Statement apply(Statement base, Description description);
~~~
Instead of using a `FramewordMethod` object
to describe the test method,
the new interface uses a `Description` object,
which gives access to essentially the same information.
The `target` object
(the instance of the test class)
is no longer provided.

# Applying Rules

To use a rule in your test class,
you declare a public member field,
initialize the field with an instance of your rule class,
and annotate the field with `@Rule`:

~~~ java
public class MyTest {
  @Rule
  public MethodRule screenshot = new ScreenshotOnFailureRule();

  @Test
  public void myTest() { ... }

  ...
}
~~~

# The Sequence of Events In Detail

JUnit now applies the rule to every test method in your test class.
Here is the sequence of events that occurs for each test
(omitting details that aren't related to rules):

 1. JUnit creates an instance of your test class.
 1. JUnit creates a default statement
    whose `evaluate()` method
    knows how to call your test method directly.
 1. JUnit inspects the test class
    to find fields annotated with `@Rule`,
    and finds the `screenshot` field.
 1. JUnit calls `screenshot.apply()`,
    passing it the default statement,
    the instance of the test class,
    and information about the test method.
 1. The `apply()` method
    creates a new `ScreenshotOnFailureStatement`,
    passing it the default statement
    and the names of the test class and test method.
 1. The `ScreenshotOnFailure()` constructor
    stashes the default statement,
    the test class name,
    and the test method name for use later.
 1. The `apply()` method
    returns the newly constructed screenshot statement to JUnit.
 1. (If there were other rules on your test class,
    JUnit would call the next one,
    passing it the statement created by your screenshot rule.
    But in this case,
    JUnit finds no further rules to apply.)
 1. JUnit calls the screenshot statement's `evaluate()` method.
 1. The screenshot statement's `evaluate()` method
    calls the default statement's `evaluate()` method.
 1. The default statement's `evaluate()` method
    invokes the test method on the test class instance.
 1. (Let's suppose that the test method throws an exception.)
 1. Your screenshot statement's `evaluate()` method
    catches the exception,
    calls the `MyScreenshooter` class to take the screenshot,
    and rethrows the caught exception.
 1. JUnit catches the exception
    and does whatever arcane things it does when tests fail.
