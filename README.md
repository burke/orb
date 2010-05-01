# ORB

# What is it?

ORB is a tool to write tests interactively. Add `ORB{}` to one of your
tests, then when you run your test suite, you'll get dropped to a
REPL, where you can explore the test's context and build an
implementation for the test, before writing it out to the file and
replacing the `ORB{}` call.

# Wait... What?

[Watch the video](#) (Coming Soon).

# Can I use this with <framework>?

Probably. Have a look at `lib/adapters/rspec.rb`. It's a pretty simple
format. 

# Why do I have to call ORB with an empty block?

Ruby 1.8.6 and onward doesn't have a reliable way to evaluate code in
the context that calls a method without explicitly passing it, or
grabbing the binding from a block. The block is easier to type.

# I have a great idea...

Great! Let me know, or even better, send me a pull request.
