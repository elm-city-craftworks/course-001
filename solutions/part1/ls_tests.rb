# Task: Implement the ruby-ls utility and get these tests to pass on a system 
# which has the UNIX ls command present.

require "open3"

dir = File.dirname(__FILE__)
Dir.chdir("#{dir}/data")

UNIX_LS = "ls"
RUBY_LS = "ruby-ls"

def check(label, args)
 if `#{UNIX_LS} #{args}` == `#{RUBY_LS} #{args}`
   puts "[OK] #{label}"
 else
   abort "[FAILED] #{label}\n\n" +
         "`#{(RUBY_LS + " " + args).strip}` does not match `#{UNIX_LS}`."
 end
end

check("No arguments", "")

check("File glob", "foo/*.txt")

check("Detailed output", "-l")

check("Hidden files", "-a")

check("Hidden files with detailed output", "-a -l")

check("File glob with detailed output", "-l foo/*.txt")

check("Invalid directory", "missingdir")

check("Invalid flag", "-Z")

############################################################################

puts "You passed the tests, yay!"

