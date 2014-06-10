## Part 4: Socket programming and network I/O

The article we'll work through in this part of the 
course is [Implementing a minimal HTTP server in Ruby](https://practicingruby.com/articles/implementing-an-http-file-server?u=dc2ab0f9bb).
Reading it carefully should prepare you to work through the questions
and exercises for this topic.

## Questions

> NOTE: Some of these questions can directly be answered by reading 
> the article, but most require you to search the web for
> answers. External research is not only OK, it's encouraged!

**Q1:** Briefly describe what a TCP socket is, using as little
jargon as possible.

**Q2:** The `Socket`, `TCPSocket`, and `TCPServer` classes provide
functionality that handles network interactions. What base class
provides most of the generic stream processing behavior they 
all have in common?

**Q3:** Describe the similarities and differences between
client-side and server-side sockets.

**Q4:** Why is it important to explicitly close sockets when you
are done using them?

**Q5:** What might lead to a socket not being properly closed?
What constructs does Ruby provide that can be used to avoid
these problems?

**Q6:** After a client-server interaction is completed, who is
responsible for closing sockets: the client, the server, or
both the client and the server? Explain your answer.

**Q7:** What strategies could you use for testing code that makes use
of sockets? Consider both unit testing and end-to-end system testing
in your response.

**Q8:** Below are two minimal `TCPServer` examples, both of which
accept incoming connections, and then respond with a "Hello World"
message after a short delay.

Suppose that three client requests arrive at roughly the same 
time. How long would you expect it to take for each server 
implementation to process the three requests? 

*Implementation #1:*

```ruby
require "socket"

server = TCPServer.new 2000

loop do
  client = server.accept 

  sleep 10

  client.puts "Hello World!"
  client.puts "Time is #{Time.now}"

  client.close
end
```

*Implementation #2:*

```ruby
require "socket"

server = TCPServer.new 2000

loop do
  Thread.start(server.accept) do |client|
    sleep 10

    client.puts "Hello World!"
    client.puts "Time is #{Time.now}"

    client.close
  end
end
```

You can experimentally verify your answer using a command line
tool like `telnet`. You should only need to establish a connection
to test out the server behavior, as in the following example:

```
$ telnet localhost 2000
Trying 127.0.0.1...
Connected to localhost.
Escape character is '^]'.
Hello World!
Time is 2014-06-09 12:20:31 -0400
Connection closed by foreign host.
```

## Exercises

In this set of exercises, you will build a minimal Internet Relay Chat (IRC)
client, using nothing but basic socket programming.

**STEP 1:** Read through [IRC Over Telnet](http://oreilly.com/pub/h/1963), and
follow along using `telnet` on your own machine. 

You can join any channel you'd like for experimentation, but are welcome to try using
`#practicing-ruby-testing` if you want to encounter other Practicing Rubyists
testing their bots.

You may want to also connect using a regular IRC client to see what the effects of
your telnet-based experiments are. If you're not familiar with IRC, you can
use the following link to access a web client which will randomly generate a 
nickname for you and connect you to the `#practicing-ruby-testing` channel:

http://webchat.freenode.net/?randomnick=1&channels=%23practicing-ruby-testing&uio=d4

**STEP 2:** Using the `TCPSocket` class, establish a socket connection to
`irc.freenode.net` on port `6667`. Once you're connected, set your `NICK`
and `USER` information using the commands shown in the *IRC Over Telnet* 
article, then join a channel and post a "Hello World" message using the
`PRIVMSG` command. Finally, issue a `QUIT` message and close the socket
connection.

**STEP 3:** Create a loop to process incoming messages from the server.
Whenever a `PING` command is received, respond with an appropriate
`PONG` command to keep your connection from being terminated. Whenever
a `PRIVMSG` command is received, print the message contents to STDOUT.

**STEP 4:** Choose a special word for your bot to monitor the chat logs
for. Whenever this word is mentioned, send a message in response. For
example, you might have your bot respond "MINASWAN!" every time someone
mentions the word "Matz".

**STEP 5:** Make your client more robust by handling common error conditions
(e.g. when a given nickname is already in use), and make the nickname
used by your bot configurable at runtime. Try to cleanly close your socket
connections when possible, and make your error messages human readable and clear.

The [IRC Over Telnet](http://oreilly.com/pub/h/1963) article combined
with the [TCPSocket](http://ruby-doc.org/stdlib-2.1.1/libdoc/socket/rdoc/TCPSocket.html) 
API documention should give you enough information to complete this set of exercises, 
but if you want much more detailed information on the IRC protocol, you can check out RFC 1459. In
particular, look at the following sections:

* [4.1.2 Nick message](http://tools.ietf.org/html/rfc1459.html#section-4.1.2)
* [4.1.3 User message](http://tools.ietf.org/html/rfc1459.html#section-4.1.3)
* [4.1.6 Quit message](http://tools.ietf.org/html/rfc1459.html#section-4.1.6)
* [4.2.1 Join message](http://tools.ietf.org/html/rfc1459.html#section-4.2.1)
* [4.4.1 Private messages](http://tools.ietf.org/html/rfc1459.html#section-4.4.1)
* [4.6.2 Ping message](http://tools.ietf.org/html/rfc1459.html#section-4.6.2)
* [4.6.3 Pong message](http://tools.ietf.org/html/rfc1459.html#section-4.6.3)

If you get stuck and have any questions, don't hesitate to file an issue
in this repository or ask for help in the Practicing Ruby campfire chat.
