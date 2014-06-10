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
of sockets?. Consider both unit testing and end-to-end system testing
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

> NOTE: The supporting materials for these exercises are in `samples/part4`

[part4-samples]: https://github.com/elm-city-craftworks/course-001/tree/master/samples/part4
