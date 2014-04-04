# Task: Implement the ruby-ls utility and get these tests to pass on a system 
# which has the UNIX ls command present.

require "open3"

dir = File.dirname(__FILE__)
Dir.chdir("#{dir}/data")

def check(args)
  ls, rls = `ls #{args} 2>&1`, `ruby-ls #{args} 2>&1`
  unless ls == rls
    puts "ls #{args}"
    puts
    puts "LS>>", ls, "<<"
    puts
    puts "RLS>>", rls, "<<"
    abort "Failed #{args}"
  end
end

############################################################################

check ""

puts "Test 1: OK"

############################################################################

check "foo/*.txt"

puts "Test 2: OK"

############################################################################

check "-l"

puts "Test 3: OK"

############################################################################

check "-a"

puts "Test 4: OK"

############################################################################

check "-a -l"

puts "Test 5: OK"

############################################################################

check "-l foo/*.txt"

puts "Test 6: OK"

############################################################################

check "missingdir"

puts "Test 7: OK"

############################################################################

check "-Z"

puts "Test 8: OK"

############################################################################

puts "You passed the tests, yay!"

