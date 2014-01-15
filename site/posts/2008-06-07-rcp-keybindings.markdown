--- 
categories: 
- Coding
date: 2008/06/07 09:45:43
tags: []

title: Key Bindings in Eclipse/RCP Applications
comments: true
published: true
layout: post
---

<strong>THE CONTEXT</strong>

I very recently started to write my first application based on the <a href="http://wiki.eclipse.org/index.php/Rich_Client_Platform" title="Rich Client Platform page on the Eclipse Wiki">eclipse Rich Client Platform</a>.  RCP is a wicked neato platform that automagically implements all kinds of UI features that you would otherwise have to either program manually or leave out of your app.  RCP FTW!

My app is <em>dalewriter</em>, a tool to help me write and organize stories, articles, and books.  (I'm a geek, which means that instead of writing stories, articles, and books, I spend my time creating tools to help me write stories articles and books.)  <em>dalewriter</em> will allow me to edit text, store it a tree form (chunks of text in a tree of folders), shuffle and reorder the bits, and build a manuscript from the tree or a subtree.

Six days ago I didn't know nothin' 'bout no RCP, so I've been using  McAffer and Lemieux's <a href="http://www.amazon.com/exec/obidos/ASIN/0321334612/dalehemery-20" title="Designing, Coding, and Packaging Java(TM) Applications">RCP book</a>, following along with their running example and adjusting what I learned to fit my app instead of theirs.

Development was going swimmingly until I tried to establish my first key binding--the connection that makes a given keystroke cause a given action.  I wanted <font face="Courier New">CTRL-N</font> to create a new text item in the currently selected folder and open it for editing.  I'd already written and tested the action itself, and now I wanted to connect <font face="Courier New">CTRL-N</font> to the action.

<strong>THE PROBLEM</strong>

I followed the example in the book, and it didn't work right.  I wish I could tell you the exact failure, but I wasn't expecting that I would (have to) learn so danged much that I'd want to write about it.  I spent a great deal of the next few days (and long, long nights) tracking down everything I could find on the Interwebs about key bindings.

Part of the problem is that eclipse's key-binding mechanism has changed over the past few releases, and much of the information I found referred to old-style bindings.  I tried each idea I found.  Each one led to "hey, dood, cut that out, that's deprecated" warnings.  (I'm paraphrasing slightly.)

And not only that, they didn't work.  I observed three general "not what I wanted it to do" responses from my app when I typed <font face="Courier New">CTRL-N</font>:
<ul>
	<li>Ding at me (the standard Windows warning ding) without creating a new item.  I came to interpret this as a sign that <font face="Courier New">CTRL-N</font> was not bound to any action.</li>
	<li>Open the "Select a wizard" dialog, a standard eclipse dialog that allows the user to select among a list of things to create.  This appears to be the default eclipse action for <font face="Courier New">CTRL-N</font>.</li>
	<li>Open a little yellow table in the bottom right corner of the window, asking me to select which action I wanted to take.  The choices were labeled "New" and "New Item".  The "New" choice invoked the "Select a wizard dialog".  The "New Item" choice was the one I had created.  Hey!  That's progress!  It still wasn't right--I wanted <font face="Courier New">CTRL-N</font> to directly invoke my action instead of first asking the user (i.e. me) to choose, but still, that was progress.</li>
</ul>
Finally, I somehow pieced together disparate examples and descriptions of bindings and related mechanisms, and found a solution.

Given how many other people have stumbled over eclipse/RCP key-binding quirks, I thought I'd describe the solution I found, my understanding of why this solution works, and ideas for what to do if you're having trouble.  You're welcome.

<strong>THE SOLUTION</strong>

Before I describe what worked, <strong><em><u>A CAVEAT</u></em></strong>:  I still don't know hardly nothin' 'bout no RCP.  As I said, I've been working with RCP for less than six days, so take everything I say here with a bag of salt.  I've done my best to explain my understanding of how and why this works, but I'm no authority.  Yet.

The key ingredients of the whole enchilada are:
<ol>
	<li>An <em>action</em> to invoke.</li>
	<li>A <em>command</em> that invokes the action.</li>
	<li>A <em>key binding</em> that invokes the command (that invokes the action).</li>
	<li>A <em>plug-in configuration file</em> that enables your key bindings.</li>
</ol>
<h3></h3>
<strong>Action.</strong>  First, create an action that the keystroke will invoke.  I'll assume that you know how to create an Action in RCP.  If you need help with this, see the <a href="http://www.amazon.com/exec/obidos/ASIN/0321334612/dalehemery-20" title="Designing, Coding, and Packaging Java(TM) Applications">RCP book</a>.

The secret sauce here is that you have <em>to make the action available for invocation by commands</em>.  To do that:
<ol>
	<li>Make up a unique identifier string that will represent the command.  I chose <font face="Courier New">com.dhemery.dalewriter.command.AddItem</font>.</li>
	<li>In the constructor of your action, call the <font face="Courier New">setActionDefinitionId()</font> method, passing it the identifier you created.  When the command is invoked, RCP will look for a registered action that has this action definition ID, and invoke it.</li>
	<li>In <font face="Courier New">ApplicationActionBarAdvisor.makeActions()</font>, register your action in the usual way (see the <a href="http://www.amazon.com/exec/obidos/ASIN/0321334612/dalehemery-20" title="Designing, Coding, and Packaging Java(TM) Applications">RCP book</a>).</li>
</ol>
<strong>Command.</strong>  There is no way to connect a key binding directly to an action.  Apparently there used to be, but the old mechanism either gone or deprecated.  To connect a key binding to an action, you create an intermediary called a <em>command</em>.  You do this not with Java code, but by declaring a command extension:
<ol>
	<li>Add the <font face="Courier New">org.eclipse.ui.commands</font> extension point to your <font face="Courier New">plugin.xml</font> file (on the Extensions tab of your <font face="Courier New">plugin.xml</font> file).</li>
	<li>Add a new command:  Right click on the commands extension point and select <em>New &gt; command</em>.
<ul>
	<li>In the <em>id*</em> field of the new command, enter the command identifier that you used to register your action (e.g. <font face="Courier New">com.dhemery.dalewriter.command.AddItem</font>).  This connects the command to the action.  When the command is invoked--such as in response to a user keystroke--RCP will invoke the action that you have registered with this ID.  The <em>id*</em> that you enter into this field must be <em>identical</em> to the one with which you registered the action.</li>
	<li>Use whatever <em>name*</em> and <em>description</em> you like.  Those fields don't affect key bindings.</li>
</ul>
</li>
</ol>
<strong>Key Binding.</strong>  Next, you need a <em>key binding</em> and a <em>key binding scheme</em>.  The key binding connects a specified keystroke to your command.  A <em>key binding scheme</em> is a named bundle of key bindings that can be enabled all at once.
<ol>
	<li>Add the <font face="Courier New">org.eclipse.ui.bindings</font> extension point to your <font face="Courier New">plugin.xml</font> file.</li>
	<li>Create a key binding scheme:  Right click on the bindings extension point and select <em>New &gt; scheme</em>.
<ul>
	<li>Give your scheme a unique identifier in the <em>id*</em> field.  I used <font face="Courier New">com.dhemery.dalewriter.bindings</font>.</li>
	<li>Use whatever <em>name*</em> and <em>description</em> you like.  These fields don't affect key bindings.</li>
	<li>You can leave the <em>parentId</em> field blank.  Or if you want to make a ten-pound bag of default actions available to your app, see the "Bonus: Default Bindings and Actions" section below.</li>
</ul>
</li>
	<li>Create a key binding:  Right click on the bindings extension point and select <em>New &gt; key</em>.
<ul>
	<li>In the <em>sequence*</em> field, enter the key (or key chord) that will invoke your action (e.g. <font face="Courier New">M1+N</font> or <font face="Courier New">CTRL-N</font>).</li>
	<li>In the <em>schemeId*</em> field, enter the identifier you assigned to your new binding scheme.  This tells RCP to active this binding whenever the scheme is active.</li>
	<li>In the <em>commandId field</em>, enter the command identifier that you made up way back in step one.  This is the command id that you assigned to the command extension, and that you used to register the action.  For me, the <em>commandid</em> was <font face="Courier New">com.dhemery.dalewriter.command.AddItem</font>.</li>
	<li>For the love of all that is good and holy, don't mess with <em>contextId</em>, <em>platform</em>, or <em>locale</em>.  If you're indifferent to all that is good and holy, make up your own reason not to mess with those fields.</li>
</ul>
</li>
</ol>
<strong>Plug-In Configuration File.</strong>  To activate your binding scheme (and thus all of its bindings), you use a <em>property</em> in a <em>plug-in configuration file</em>:
<ol>
	<li>Create a new plug-in configuration file in your project.  This is just a plain text file.  I added mine directly under the project and called it <font face="Courier New">plugin_customization.ini</font> (which seems to be the standard name).</li>
	<li>Add a <font face="Courier New">KEY_CONFIGURATION_ID</font> property in the file to tell RCP to activate your binding scheme whenever your plug-in is active.  To do that, add a line like this:
<ul>
	<li><font color="#999999" face="Courier New">org.eclipse.ui/KEY_CONFIGURATION_ID=com.dhemery.dalewriter.bindings</font></li>
</ul>
</li>
	<li>Add a <font face="Courier New">preferenceCustomization</font> property to your product extension.  This tells RCP to load your configuration file and apply its preferences when it activates your plug-in.
<ul>
	<li>Find your product extension under the <font face="Courier New">org.eclipse.core.runtime.products</font> extension point in the <font face="Courier New">plugin.xml</font> file.  If your application doesn't yet have a product extension, see the <a href="http://www.amazon.com/exec/obidos/ASIN/0321334612/dalehemery-20" title="Designing, Coding, and Packaging Java(TM) Applications">RCP book</a> for instructions on how to create one.</li>
	<li>Right click your product extension and select <em>New &gt; property</em>.</li>
	<li>In the <em>name*</em> field, enter <font face="Courier New">preferenceCustomization</font>.  When RCP starts up your application, it will look up this property to identify the plug-in configuration file to apply.</li>
	<li>In the <em>value*</em> field, enter the name (and path, if appropriate) of your plug-in configuration file.</li>
</ul>
</li>
</ol>
Yep, it's as simple as that.  (Yep, that was irony--a subtle form of we Mainers call <em>hyoomah</em>.)

If you know what you're doing, you can define the command, the binding scheme, the key binding, and the customization property directly in raw XML in the <font face="Courier New">plugin.xml</font> file.  If you don't know what you're doing, your <font face="Courier New">plugin.xml</font> file will become <a href="http://dictionary.reference.com/browse/contumaciously" title="Richard was using this word.  I have no idea what it means.">contumaciously</a> hosed (<em>hosed</em> being a technical term that means (roughly):  <em>hosed)</em>.  I will leave it to the reader to infer how I know this.

Before I move on to troubleshooting, here's one more bit of useful information.

<strong>Bonus:  Default Bindings and Actions.</strong>  eclipse/RCP includes a default key binding scheme the defines key bindings for a passel of groovy built-in actions (e.g. <font face="Courier New">CTRL-S</font> to save).  Now, it turns out that the default scheme is the bastard that <a href="http://dictionary.reference.com/browse/eruct" title="Richard was using this word, too.  I don't know what it means, either.">eructs</a> that annoying "Select a wizard" dialog when I press <font face="Courier New">CTRL-N</font> in <em>dalewriter</em>.  Mumble grumble.

But wait, here's the wickedest awesomest part:  There's a way for your key binding scheme to inherit all of the cool defaults, use the ones you want, override the ones you want to override, and <a href="http://dictionary.reference.com/browse/defenestrate" title="Richard again.">defenestrate</a> the ones you don't want.  Here's the straight dope:
<ul>
	<li>To make the default bindings and actions available in your own binding scheme, make the default scheme the parent of yours: In the <em>parentId</em> field of your scheme, enter <font face="Courier New">org.eclipse.ui.defaultAcceleratorConfiguration</font>.</li>
	<li>If you want a keystroke to trigger an action of your own rather than the default action, simply add a key binding of your own into your scheme.  Yeah, okay, so that's not so simple:  You still have to do all of the crap in the previous sections.  But still.</li>
	<li>If you want to disconnect a default binding from your app without overriding it, simply add a binding to your scheme, enter the appropriate key chord in the <em>sequence*</em> field, and leave the <em>commandId</em> field empty.  See?  This time when I said <em>simply</em>, I really meant <em>simply</em>.  Leaving the <em>commandId</em> field blank tells RCP "when the user presses these keys, do nothing."</li>
</ul>
<strong>TROUBLESHOOTING RCP KEY BINDING PROBLEMS</strong>

Here are the primary failures I've observed, and possible solutions.

<strong>The "<em>Dreaded Ding"</em> Problem:  Your app <em>emits a warning ding</em></strong> instead of executing your action.  This is a sign that <em>your app has no active key binding for that keystroke</em>.  In order for a keystroke to find the right action, there's a long chain of links that must be established correctly.

<em>Solution</em>.  Here are some things to check:
<ul>
	<li>Did you make up a command ID that is absolutely unique within your app?  I don't know what happens if there are duplicate command IDs.  I suspect it would destroy Western civilization.</li>
	<li>Did you call <font face="Courier New">setActionDefinitionId()</font> in your action's constructor?  If not, your action is not available to be invoked by commands.</li>
	<li>Did you pass the correct command ID to <font face="Courier New">setActionDefinitionId()</font>?  The string that you pass must be <em>identical</em> to the string you entered into your command extension's <em>id*</em> field.  If you passed an incorrect string, RCP won't find your action (and therefore won't execute it) when the command fires.</li>
	<li>Did you register your action by calling <font face="Courier New">register(action)</font> within <font face="Courier New">ApplicationActionBarAdvisor.makeActions()</font>?  If you omit this call, your action won't be registered with RCP, so RCP won't be able to find and execute your action when the command fires.</li>
	<li>Did you define a command extension?  If you omit this, RCP will not know to associate your key binding with your action.</li>
	<li>Did you assign your command the correct <em>id*</em>?  If the <em>id*</em> is incorrect, RCP will not find your action when the command fires.</li>
	<li>Did you define a binding scheme for your key bindings?  If you omit binding scheme, RCP will not know to activate your binding.</li>
	<li>Did you assign the binding scheme a unique <em>id*</em>?  I don't know what happens if there are duplicate binding scheme IDs.  Again, Western civilization hangs in the balance, and even Obama won't be able to fix this.</li>
	<li>Did you define a key binding?  If you omit the key binding, RCP won't know what to do when the user types the keystroke.  (Could I say "when the user strokes the keys," or would that just be weird?)</li>
	<li>Did you specify the correct key <em>sequence*</em> in the key binding?  If the <em>sequence*</em> is incorrect, your action may fire when the user strokes some other keys.  (Hmmm.  Yes, I guess that <em>does</em> sound weird.)</li>
	<li>Did you assign your key binding to your binding scheme?  If you assign the key binding to an incorrect binding schemes, then even if your binding scheme is active, your key binding will not be.</li>
	<li>Did you create a plug-in customization file?  If you omit the customization file, RCP will not know that you have a binding scheme (or other preferences) for it to load when it loads your plug-in.</li>
	<li>Did you include your plug-in customization file in the build?  If not, RCP won't find your customizations when it looks for them.</li>
	<li>Did you add a <font face="Courier New">preferenceCustomization</font> property to your product?  If you omit this property, RCP will not know about your preferences file, and so will not load your preferences.</li>
	<li>Did you assign the <font face="Courier New">preferenceCustomization</font> the right <em>value*</em>?  This <em>value*</em> be the name your plug-in customization file, along with the file path if you put the file somewhere other than directly the project.  If you assign an incorrect <em>value*</em>, RCP will load (or attempt to load) the wrong set of preferences when it loads your plug-in.</li>
	<li>Did you add the <font face="Courier New">org.eclipse.ui/KEY_CONFIGURATION_ID</font> property to your plug-in customization file?  If you omit this property, then won't know that you want it to activate your binding scheme.</li>
	<li>Did you assign the <font face="Courier New">KEY_CONFIGURATION_ID</font> property the right value?  This must be the unique identifier for your binding scheme.  If value of this property is incorrect, RCP will activate (or try to active) a binding scheme other than the one you intend.</li>
</ul>
<strong>The "<em>Multiple Choice"</em> Problem</strong><strong>:  Your app <em>displays a little yellow table</em></strong> (like the picture below) that displays a number of actions that you can choose to execute.  This is a sign that <em>the active binding scheme has two or more bindings for the same keystroke</em>.  I stumbled over this when (in my willingness to try <em>anything</em>) I assigned my key binding to eclipse/RCP's default binding scheme (<font face="Courier New">org.eclipse.ui.defaultAcceleratorConfiguration</font>).  This made all of the cool default bindings available to my app, but it created a conflict between my <font face="Courier New">CTRL-N</font> binding and the "Select a wizard" <font face="Courier New">CTRL-N</font> binding already in the default scheme. When you execute a keystroke for which the active scheme has two bindings, eclipse/RCP requires the user to take the extra step of choosing between the several possible actions:.

<img src="http://lh6.ggpht.com/dhemery/SEo9w_-gACI/AAAAAAAAAZE/8rXyKUeSgpM/s288/RCPKeyBindingConflict.jpg" alt="Example of an eclipse/RCP key binding conflict" width="202" align="baseline" height="111" />

<em>Solution</em>.  Assign your key binding to your own binding scheme, and not to the default one.  If you also want your app to inherit all of the other key bindings from the default scheme, follow the instructions in the "Bonus:  Default Bindings and Actions" section above.

<strong>The <em>"Wrong Action"</em> Problem:  Your app <em>executes some other action</em></strong> (e.g. the default "Select a wizard" dialog) instead of your action.  This primary trouble here is the same as in The "Dreaded Ding" Problem:  <em>Your key binding is not active</em>.  The difference here is that some other scheme has activated a key binding for the relevant keystroke.  Your key binding is not active, but some other key binding <em>is</em> active.

<em>Solution.</em>  First activate your key binding by working through the checklist for The "Dreaded Ding" Problem.  If this causes you to lose all of the useful actions from the default scheme, make sure to declare the default scheme as a parent of your scheme, as described in the "Bonus:  Default Bindings and Actions" section above.

<strong>EXPLORING ON YOUR OWN </strong>

If none of my ideas solve the problem for you, well, that's all the ideas I have right now, so you'll have to gather more information either from your program or <a href="http://www.google.com/search?q=RCP+eclipse+key+bindings+problem">from the innertoobs</a>.

To help you explore your program, I'll toss you one last cookie.  Here's a programmatic way to print the active binding scheme and a list of all active key bindings:
<pre>IWorkbench workbench = PlatformUI.getWorkbench();</pre>
<pre>IBindingService bindingService = (IBindingService)workbench.getAdapter(IBindingService.class);</pre>
<pre>System.out.println(bindingService.getActiveScheme());</pre>
<pre>for(Binding binding : bindingService.getBindings()) {
    System.out.println(binding);
}</pre>
