---
date: "2014-10-24T00:00:00Z"
tags:
- test automation
title: Diagnostic assertions
---

When we write an assertion statement,
naturally we want to make the code expressive.
We want the assertion statement
to include all of the information that matters to the assertion,
and no extraneous information.
We want it to be clear to the reader
just what we are asserting.

When writing assertion statements,
test automators often neglect an important consideration:
**the diagnostic value of the _message_
that is displayed if the assertion fails.**

Given how carefully we craft our assertion statements,
it's a shame when the assertion failure message
throws away important information,
or when it swamps us with noise
that hides the information that we want most.

Some assertion mechanisms naturally lose information
when they create failure messages.
Other mechanisms allow us to
**make the failure messages
as clear and informative as the assertion statements themselves.**

I will demonstrate using Java, JUnit,
Hamcrest, and a few other libraries.
You will find similar assertion mechanisms and features
in other programming languages and libraries.




## Example

Let's set up an example that we can use to explore
the diagnostic value of different kinds of assertions.

**A class.**
Here is a very simple class, an item with text:

~~~ java
public class Item {
    private final String text;

    public Item(String text) {
        this.text = text;
    }

    public String text() {
        return text;
    }
}
~~~

**A test.**
Here is a test:

~~~ java
public void findItemReturnsAnItemWithTextFoo() {
    Item item = someObject.findItem();
    assert item.text() == "foo";
}
~~~

The test asks `someObject` to find an item,
then asserts that the item's text is equal to `"foo"`.

**A fault.**
The code being tested has a fault:
It gives the item the incorrect text value `"bar"`
instead of the desired value `"foo"`.

**A failure.**
Given that fault,
our assertion will fail.
When the assertion statement executes,
it will detect that the value is incorrect
and throw an exception to indicate an assertion failure.
Then JUnit will display the exception, including any diagnostic message contained in the exception.




## Assertion Styles

There are many ways to express our desired assertion in Java,
especially if we use assertion mechanisms from third-party libraries,
such as JUnit, Hamcrest, and Hartley.
Each of the following assertion statements
correctly evaluates whether our item's text is equal to `"foo"`,
and each correctly throws an exception if the text does not have the desired value.

Let's look at each of these styles,
and notice what information is included in the failure message,
and what information is lost.




## The Java _assert_ Statement

Our example test
expresses an assertion using a Java assertion statement:

~~~ java
assert item.text().equals("foo");
~~~

Notice that this short statement
gives a _lot_ of information about our intentions:

-   `assert` says that we will make an evaluation,
    and that the evaluation is so important to our test
    that we will mark the test as _failed_
    if the result is not as we've specified.
-   `item` says that we will evaluate an object called _item_
    (or some aspect of _item_).
-   `text()` says that we will evaluate some text.
-   The `.` between `item` and `text()` says
    that we will evaluate the text obtained from `item`.
-   `.equals()` says that we will compare whether `item`'s text
    is equal to some value.
-   `"foo"` says that we will compare the item's text to the literal value `"foo"`.

Each of those six pieces of information
is essential to the assertion.
If we remove any piece of information,
the assertion loses its meaning.
(Technically, we could extract the text into a local variable,
so that our assertion need not refer to `item`,
but let's assume that we've chosen this particular phrasing
because we want to make the _source_ of the text crystal clear.)

If we run this test and execute this assertion,
the assertion throws an exception,
and JUnit emits this message:

> java.lang.AssertionError

followed by a stack trace.
The stack trace indicates the Java file name and line number
from which the exception was thrown.
That is,
it indicates the file name and line number
of our assertion statement.
So if we want to understand the source of the failure,
we have to navigate to the source code
and read the assertion statement.
It's a good thing we took pains to make the assertion statement so clear,
because that's all of the information we have
as we begin our investigation of the failure.




## The (Mostly) Uninformative Failure Message

Note that the failure message itself tells us only that some assertion failed.
It gives us no information at all (in the message itself)
about what aspect of our assertion went wrong.
Remember that our assertion statement expressed
at least six important pieces of information.
The failure message conveys only _one_ of these:
This thing that went awry was an assertion.

That's a critical piece of information, of course,
but what happened to the other five pieces,
which we took such pains to express so clearly in the code?

They were thrown away by the nature of the assertion mechanism.
The Java assertion statement
consists of two parts:
the `assert` keyword and a boolean expression.
To execute an assertion statement,
Java first evaluates the boolean expression.
Then it assesses the result (`true` or `false`).
If the result is `true`,
execution continues with the following statement.
If the result is `false`,
the statement throws an exception.

In evaluating the boolean expression,
the computer loses the information the original expression,
and saves only the `true` or `false` result.
By the time the statement throws its exception,
all of the other information about the expression
has been lost.




## The JUnit _assertTrue()_ Method

Now let's try another style of assertion,
the `assertTrue()` method from JUnit:

~~~ java
assertTrue(item.text().equals("foo"));
~~~

This method produces the same error message as the bare Java `assert` statement:

>   java.lang.AssertionError

again supplemented by a stack trace that points to the assertion in the code.

The JUnit `assertTrue()` method has one advantage over the Java `assert` statement:
You don't have to tell the JVM to enable it.
If you want the JVM to execute `assert` statements,
you have to pass a special argument to the JVM.
If you don't tell the JVM to enable `assert` statements,
it (quietly) ignores them.

Otherwise, the effects of `assert` and `assertTrue()` are similar.
Each throws an `AssertionError`,
and neither gives you any of the other information
that you so carefully crafted into your assertion.




## Improving the Java _assert_ Statement with an Explanation

Both JUnit and Java offer a mechanism to compensate for the limitations
of the bare `assert` and `assertTrue()` assertions:
_the explanatory message_
(which I'll shorten to _explanation_).

With the Java `assert` statement,
you add an explanatory message like this:

~~~ java
assert item.text().equals("foo") : "Item text should be foo";
~~~

If this assertion fails,
Junit displays this message:

> java.lang.AssertionError: Item text should be foo

followed by the same stack trace as before.

That's much more informative than before.
In fact,
our failure message tells us nearly _everything_ that the code tells us.

Am I happy?
Nope.

The big problem with this explanation mechanism is that
_it requires you to express the same idea twice_,
once in the boolean expression,
and again in the explanation.
As with other forms of comments in code,
it is very easy
(and common)
for the comment to diverge from the code it describes.
You end up with failure messages that mislead.

And even if the comment stays current with the code,
it is a form of duplication.
If the code changes,
you also have to do the extra work of changing the comment.




## Adding Explanations with JUnit _assertTrue()_

JUnit includes a form of `assertTrue()` method that takes an explanation
as its first parameter:

~~~ java
assertTrue("Item text should be foo", item.text().equals("foo"));
~~~

I find this expression more awkward then the `assert` statement.
With the `assert` statement,
the explanation follows the entire assertion.
With `assertTrue()`,
the explanation interrupts the left-to-right phrasing of the assertion.

Still, this is better than no explanation at all.
The `assertTrue()` explanation has the same effect as the `assert` statement explanation.
If the assertion fails, JUnit displayes this message:

> java.lang.AssertionError: Item text should be foo




## Still Missing: The Actual Value

By adding explanatory messages to our assertions,
we can restore the information that is lost
when the assertion evaluates our boolean expression.

But now I notice another bit of information that I wish were displayed
in the failure message:
The actual value of the item's text.
Thanks to our explanations,
we know the value is not the desired `"foo"`,
but what _is_ the value?

Of course,
if we're writing our own explanations,
we could easily include the actual value in our explanatory message.
But that takes extra work.
Granted, it's not a big burden,
but it is extra work.

What if there were a way to get that information
(almost)
for free?
The actual value is assessed somewhere during the evaluation,
but it is then thrown away after the comparison is made
and we've determined the boolean result of the evaluation.
What if we could catch the value
before it was thrown away?

We can do that.
The key is to express the assertion in a way that retains both the actual value
and the desired value,
even after comparing them.




## The JUnit _assertEquals()_ Method

JUnit offers another style of assertion,
a style that,
when evaluated,
retains the separation between
the value you are evaluating
and the value you are comparing it to.
If you want to compare values for equality,
the appropriate method is (appropriately) called `assertEquals()`.
It looks like this:

~~~ java
assertEquals("foo", item.text());
~~~

Though this shifts the phrasing
(the concept of equality now appears earlier in the expression,
and the desired value now appears before the retrieval of the actual value),
we still have all six of the pieces of information
that matter to our assertion.

Our new expression is okay,
if a little clumsy English-wise.
At least it has all the pieces,
and it expresses each piece only once.

What happens when we run it?
JUnit displays this message:

> org.junit.ComparisonFailure: expected:<[foo]> but was:<[bar]>

Very interesting.
By passing the two pieces of information separately to the method,
we enable the method emit a more helpful failure message.
We give it two pieces
(the expected value and the actual value)
and it gives those two pieces back to us in the message.

We now have a piece of information that we didn't (and couldn't) express directly in our test code:
The actual value of the item's text.

Note also that we no longer get a barely informative `AssertionError`
that tells us only that something went wrong,
Now we get a more specific exception, a `ComparisonFailure`.
I find this slightly maddening.
We invoked a method dedicated to equality,
but the error message seems to remember only that we were doing some kind of comparison.

Still, this is way better than, "Hey, dude, something's busted.  _You_ figure it out."

And best of all:
We got it (nearly) for free.
We didn't have to duplicate any information in our statement.
We had only to rephrase our assertion,
to rearrange the same six important pieces of information.

So that's two and a half of our six pieces of information that now appear in the failure message:

1.  We're asserting something.
1.  We're asserting equality
    (this appears only partially in the failure message, so it counts only half).
1.  We're comparing someting to `foo`
    (note that we've lost the information that it's a string,
    but let's be generous and give this full credit).

And remember that we also get this bonus piece of information:

*   The actual value that we were evaluating.

This is an important addition.
Let's say that we now would like all seven of those pieces of information.
And we're getting three and a half of them.




## JUnit _assertEquals()_ with Explanation

JUnit offers a form of `assertEquals()` that takes an explanatory message.
Let's use that to restore a few of the pieces
that still don't get for free:

~~~ java
assertEquals("Item text", "foo", item.text());
~~~

Now the failure message is:

> org.junit.ComparisonFailure: Item text expected:<[foo]> but was:<[bar]>

We're duplicating the ideas of _item_ and _text_,
and I think we've done it in a way that also expresses
the relationship between the two.

But there's far less duplication than our earlier explanatory messages,
so this is progress.

Can we do better?




## The Hamcrest _assertThat()_ Method

Every assertion involves a comparison of some kind.
Steve Freeman and Nat Pryce took the very helpful step
of separating the comparison from the assertion method.
They accomplished this by introducing the concept of a _matcher_.
A matcher is an object
that represents some set of criteria,
and knows how to determine whether a given value matches the criteria.
Nat and Steve created a library of widely useful matchers
called _Hamcrest.[^hamcrest]_.


Hamcrest also includes an `assertThat()` method
that applies a matcher as an assertion:

~~~ java
assertThat(item.text(), equalTo("foo");
~~~

The first parameter to `assertThat()` is the value that we want to evaluate.
The second is a matcher object.
Typically you supply a matcher by calling a _factory method_ such as `equalTo()`.
Hamcrest factory methods are named so that assertion expressions read informatively in the code.
The assertion above says:
_Assert that item's text (is) equal to "foo"_.

When a Hamcrest `assertThat()` assertion fails,
it throws an exception with a message like this:

> java.lang.AssertionError:<br />
Expected: "foo<br />
but: was "bar"

This failure message is similar in content to the JUnit `assertEquals()` failure message.
The great advantage of Hamcrest-style assertions
is that you can easily extend the set of available assertions.
We will leave that as an exercise for the reader.

Hamcrest also has a version of `assertThat()` that takes an explanation as a parameter.
Normally all we need to do is describe the subject of the evaluation:

~~~ java
assertThat("Item text", item.text(), equalTo("foo"));
~~~

When this assertion fails,
it emits a message similar to the one from JUnit `assertEquals()`:

> java.lang.AssertionError: Item text<br />
Expected: "foo"<br />
but: was "bar"

As with JUnit's `assertEquals()`,
at the expense of a little bit of redundancy,
we have made our failure message express all of the information that matters to the assertion.

So our assertion messages read very similarly to JUnit's assertion messages.
But Hamcrest's assertion statements
read far more expressively in the code.




## The Hartley _assertThat()_ Method

For my own tests,
I often take a step beyond Hamcrest.
I often want to evaluate not only some subject,
but more specifically some attribute or feature or property
of the subject.
Each of the examples in earlier sections
evaluates not only `item`,
but more specifically the item's _text_
as returned by its `text()` method.

I often find it helpful to write assertion statements
that separate the subject from the feature.
I have created an assertion method to help me do that:

~~~ java
assertThat(item, text(), is("foo"));
~~~

This assertion method[^hartley]
takes three parameters.
Each parameter is an object.
The first object is the _subject_ of the assertion.
In this case, we are evaluating `item`.

The second parameter is the _feature_ being evaluated.
In the same way that Hamcrest matchers are objects that evaluate other objects,
Hartley _features_ are objects that extract values from other objects.
The `text()` method is a factory method
that produces a feature object
that can retrieve the text from an item.

The third parameter is a matcher
that compares the extracted feature
to the desired criteria.

In the code,
this reads just the same as the Hamcrest assertion:

> Assert that item's text is (equalTo) "foo"

But notice what happens when this assertion fails:

> java.lang.AssertionError: Expected: Item text "foo"<br />
  but: was "bar"

With no redudancy in the assertion statement itself[^work],
we now have a failure message
that includes every important detail of the assertion.





### Footnotes

[^hamcrest]: The word _Hamcrest_ is an anagram of the word _matchers._ You can find Hamcrest matcher libraries for a variety of programming languages at [http://hamcrest.org/](http://hamcrest.org/).

[^hartley]: For this and other Java code that I find commonly useful when I automate tests, see my _[Hartley](http://dhemery.github.com/hartley)_ library.

[^work]: Note that I _did_ have to do some extra work in order to convince the failure message to describe the subject and the feature.  I had to implement the `toString()` method in both the `Item` class and in my feature object class.  For that small amount of work, I can now use those classes in many assertions, and I gain the diagnostic expressiveness at no additional cost.
