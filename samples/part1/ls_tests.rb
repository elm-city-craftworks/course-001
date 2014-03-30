# Task: Implement the ruby-ls utility and get these tests to pass on a system 
# which has the UNIX ls command present.

require "open3"

dir = File.dirname(__FILE__)
Dir.chdir("#{dir}/data")

############################################################################

ls_output      = `ruby-ls`
ruby_ls_output = `ls`

abort "Failed 'ls == ruby-ls'" unless ls_output == ruby_ls_output

puts "Test 1: OK"

############################################################################

abort "Next step: add a test for ruby-ls foo/*.txt"

puts "Test 2: OK"

############################################################################

abort "Next step: add a test for ruby-ls -l"

puts "Test 3: OK"

############################################################################

abort "Next step: add a test for ruby-ls -a"

puts "Test 4: OK"

############################################################################

abort "Next step: add a test for ruby-ls -a -l"

puts "Test 5: OK"

############################################################################

abort "Next step: add a test for ruby-ls -l foo/*.txt"

puts "Test 6: OK"

############################################################################

abort "Next step: add a test for ruby-ls missingdir (an invalid dir)"

puts "Test 7: OK"

############################################################################

abort "Next step: add a test for ruby-ls -Z (an invalid switch)"

puts "Test 8: OK"

############################################################################

puts "You passed the tests, yay!"

