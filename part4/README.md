-----

**NOTE:** For an implementation of the IRC bot exercise, see the `irc_bot` flder
and its `README.md` file.

----

## Answers to reading questrions from Part 4

**Q1: Briefly describe what a TCP socket is, using as little
jargon as possible.**

A socket allows basic I/O operations between a client and server
over a network connection. Different protocols are used by sockets,
but TCP is most common for internet-based communications.

Operating systems provide a low-level socket API, which is wrapped
by higher level languages (including Ruby). Once a socket is created
and the network connections have been established, it is possible
to use it for basic I/O operations on a stream, similar to working
with a file or STDIN/STDOUT.

It is possible to implement any sort of internet protocol using TCP sockets,
including HTTP, FTP, IRC, etc.

**Q2: The `Socket`, `TCPSocket`, and `TCPServer` classes provide
functionality that handles network interactions. What base class
provides most of the generic stream processing behavior they 
all have in common?**

Ruby's I/O class. This makes sense because at the OS level,
sockets are treated similarly to files for basic reading,
writing, and stream processing operations.

This notion of treating everything like a file is pervasive in
Unix-like systems. For more details, see the following article:

http://ph7spot.com/musings/in-unix-everything-is-a-file

**Q3: Describe the similarities and differences between
client-side and server-side sockets.**

There are two distinct types of sockets, *connection sockets*
and *listening sockets*. Clients only need to make use of
connection sockets, while servers make use of both socket types.

When a client communicates with a TCP server, it creates a
socket by specifying the remote IP address and port and then
attempts to establish a connection.

On the server-side, a listening socket is bound to a particular
port, and its job is accepting incoming client connections.
Once a connection is established, it creates a connection
socket similar to the one used client-side to allow data
to be passed back and forth between the client and server.

The main difference between a listening socket and a connection 
socket (apart from their different use cases) is that the port
used by a listening socket is typically explicitly defined
and known in advance, whereas connection sockets are usually
randomly assigned ports from the *ephemeral port range*. We
don't often think about this when making network connections,
but it provides a nice bit of symmetry in that network
connections utilize the port interface on both the client
and server side.

All reading and writing operations are done on *connection*
sockets, which provide the same I/O-like functionality
both on the client and server side.

**Q4 Why is it important to explicitly close sockets when you
are done using them?**

When your program exits, connections will be closed for you.
But explicitly closing connecitons helps conserve resources
and prevents your process from exceeding its open file limit.

Ruby's GC will close connections that no longer are referenced
anywhere, but explicitly closing them yourself frees their
resources immediately.

Closing the connection when you are done with it also helps
ensure the remote connection does not attempt to send
more data or continue to wait for a response from your process.

**Q5: What might lead to a socket not being properly closed?
What constructs does Ruby provide that can be used to avoid
these problems?**

Consider the following server code, which establishes a
connection to a client and then attempts to carry out
two write operations:

```ruby
require "socket"

Socket.tcp_server_loop(2000) do |c|
  puts "connection established!"

  sleep 2

  puts "first write to client"
  c.puts "First write"

  sleep 2

  puts "second write to client"
  c.puts "Second write"

  c.close
end
```

If the client does not stay connected long enough to
receive the data sent by the server, an error will
be raised on the second write operation. You can
simulate this scenario by running the following code:

```ruby
require "socket"

client = Socket.tcp("localhost", 2000)
abort "Not going to wait around for an answer!"
```

Because the client connection is terminated almost
immediately after it has been established, the server loop
ends up crashing with a `Errno::EPIPE` broken pipe error.

To prevent a broken connection from halting the server, some basic 
error handling code is needed:

```ruby
require "socket"

Socket.tcp_server_loop(2000) do |c|
  begin
    puts "connection established!"

    sleep 2

    puts "first write to client"
    c.puts "First write"

    puts "second write to client"
    c.puts "Second write"
  rescue StandardError => e
    STDERR.puts "Ooops! Broken connection. #{e}"
  ensure
    c.close
  end
end
```

With this new code in place, the server gracefully handles
the failed client connection by rescuing and reporting
on the raised error. An `ensure` block is used for
closing the connection socket, which makes sure that
it gets closed properly whether an error was raised or not.

Because client code can experience the same kinds of
failures when a server unexpectedly halts a connection,
the `begin/rescue/ensure` pattern shown above can be 
useful when building client applications as well as servers.

> NOTE: If you're interested in why the connection fails 
on the second write operation rather than the first,
see this StackOverflow answer:
>
> http://stackoverflow.com/questions/2530652/ruby-tcpsocket-doesnt-notice-it-when-server-is-killed/9345818#9345818

**Q6: After a client-server interaction is completed, who is
responsible for closing sockets: the client, the server, or
both the client and the server? Explain your answer.**

Because both the client and server maintain their own
connection sockets, both are responsible for closing their
own sockets. Closing just one side of the connection
will halt communication, but this will only be discovered
when one side attempts to read or write to the other side,
and resources won't be freed until each socket is 
explicitly closed.

The server is also responsible for closing its listening socket. 
Most server applications run in an infinite loop, and so these 
sockets are not typically explicitly closed but instead are 
closed by Ruby when the process terminates. However, the
listening socket can be explicitly closed if you want to
stop accepting connections without halting the server process.

**Q7: What strategies could you use for testing code that makes use
of sockets? Consider both unit testing and end-to-end system testing
in your response.**

For unit testing, you can try to separate your network communication
code into its own adapter object, and then swap out the adapter with
a mock object or a stub whenever you're testing things that aren't
directly related to network interactions.

For integration tests or end-to-end tests, it's possible to set up
a production-like staging environment that provides a realistic
server implementation that can easily be reset to a known state, but
it might involve a lot of effort depending on the scope of your project.

If you want to test end-to-end in a clientside
application without having to have a fully functional server to test
against, you can create a dummy server application that implements stubs 
for only the interactions you're interested in. This can be turned on at the
start of a test run and shut off immediately when the tests complete,
all on the same machine.

Similar techniques can be used for testing client interactions with
server software, although that is somewhat of a more involved problem.

The book "Growing Object Oriented Software, Guided By Tests" does a great 
job of showing how to effectively test network applications. Check it out 
if this is a problem you need to solve in your own work.

**Q8: Below are two minimal `TCPServer` examples, both of which
accept incoming connections, and then respond with a "Hello World"
message after a short delay.**

**Suppose that three client requests arrive at roughly the same 
time. How long would you expect it to take for each server 
implementation to process the three requests?**

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

The first server implementation accepts incoming requests sequentially, 
so while one request is being handled, the rest pile up in a connection queue. 
Each time `server.accept` is called, a single connection is popped off that 
queue and processed. Due to the `sleep(10)` call in the main loop, we can 
expect the three requests to take at least 30 seconds to be processed.

The second server implementation also accepts new connections sequentially,
but all of the actual processing for each request is done in its own thread.
So we can expect that these threads will run the `sleep(10)` calls
simultaneously, and so all three requests will be fulfilled in slightly
over 10 seconds.

This is a very naive implementation of a threaded socket application, and
does not take robustness or error handling into account. For much more
detailed instructions on how to build a multi-threaded socket application,
see Jesse Storimer's "Working with TCP Sockets" book.
