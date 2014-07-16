require "socket"

module Bot
  def self.respond_to(message)
    case message
    when /(Hello|Hi)/i
      yield "Good day!"
    when /Bye/i
      yield "See you later!"
    end
  end

  def self.run(nick, name, channel)
    socket = TCPSocket.new("irc.freenode.net", 6667)

    socket.puts("NICK #{nick}")
    socket.puts("USER #{nick} 8 * :#{name}")

    socket.puts("JOIN #{channel}")

    loop do
      line = socket.gets
      case line
      when /PING :(.*)/
        socket.puts("PONG :#{$1}")
      when /PRIVMSG #{channel} :(.*)/
        respond_to($1) { |m| socket.puts("PRIVMSG #{channel} :#{m}") }
      else
        STDERR.puts "#{Time.now.strftime("%Y-%m-%d %H:%M:%S")} -- #{line}"
      end
    end
  rescue Interrupt
    puts "Shutting down."

    socket.puts("QUIT")
    socket.close
  end
end

nick    = ENV["IRC_NICKNAME"]
name    = ENV["IRC_FULLNAME"] || nick
channel = ENV["IRC_CHANNEL"]

Bot.run(nick, name, channel)
