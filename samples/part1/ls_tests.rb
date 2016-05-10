eval(DATA.read) # load the test helper script

# Task: Implement the ruby-ls utility and get these tests to pass on a system 
# which has the UNIX ls command present.

check("No arguments", "")

# TODO: Uncomment each test below and get it to pass.

check("Dir listing", "foo")

check("File glob", "foo/*.txt")

check("Detailed output", "-l")

check("Hidden files", "-a")

check("Hidden files with detailed output", "-a -l")

check("File glob with detailed output", "-l foo/*.txt")

check("Invalid directory", "missingdir")

check("Invalid flag", "-Z")

puts "You passed the tests, yay!"

__END__
# This test runner is from Jacob Tjoernholm
# https://github.com/elm-city-craftworks/course-001/pull/2
#
# YOU SHOULD NOT NEED TO MODIFY IT UNLESS YOU WANT
# TO TWEAK ITS OUTPUT IN SOME WAY.

dir = File.dirname(__FILE__)
Dir.chdir("#{dir}/data")

require "open3"

def check(test_name, args)
  ls_stdout, ls_stderr, ls_status = Open3.capture3("ls #{args}")
  rb_stdout, rb_stderr, rb_status = Open3.capture3("ruby-ls #{args}")

  unless (ls_stdout == rb_stdout) &&
    (ls_stderr == rb_stderr) &&
    (ls_status.exitstatus == rb_status.exitstatus)

    [
      "#{test_name} failed: Outputs do not match.",
      "Args: #{args}",
      "stdout from ls (size #{ls_stdout.size}):\n#{ls_stdout}",
      "stdout from ruby-ls (size #{rb_stdout.size}):\n#{rb_stdout}",
      "stderr from ls (size #{ls_stderr.size}):\n#{ls_stderr}",
      "stderr from ruby-ls (size #{rb_stderr.size}):\n#{rb_stderr}",
      "status from ls:\n#{ls_status.exitstatus}",
      "status from ruby-ls:\n#{rb_status.exitstatus}"

    ].each do |line|
      puts "#{line}\n\n"
    end

    abort
  end

  puts "#{test_name} OK."
end


