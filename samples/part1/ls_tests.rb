require "open3"

dir = File.dirname(__FILE__)
Dir.chdir("#{dir}/data")

def compare(args, test_name)
  ls_output = `ls #{args}`
  ruby_ls_output = `ruby-ls #{args}`

  unless ls_output == ruby_ls_output
    [
      "Args: #{args}",
      "Output from ls (size #{ls_output.size}):\n#{ls_output}",
      "Output from ruby-ls (size #{ruby_ls_output.size}):\n#{ruby_ls_output}",
      "#{test_name} failed: Outputs do not match"
    ].each do |line|
      puts "#{line}\n\n"
    end

    abort
  end

  puts "#{test_name} OK."
end

compare(""          ,  "Test 1")
compare("foo/*.txt" ,  "Test 2")
compare("-l"        ,  "Test 3")
compare("-a"        ,  "Test 4")

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

