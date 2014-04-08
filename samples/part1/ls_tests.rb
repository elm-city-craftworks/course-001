require "open3"

dir = File.dirname(__FILE__)
Dir.chdir("#{dir}/data")

def compare(args, test_name)
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

compare(""             , "Test 1")
compare("foo/*.txt"    , "Test 2")
compare("-l"           , "Test 3")
compare("-a"           , "Test 4")
compare("-a -l"        , "Test 5")
compare("-l foo/*.txt" , "Test 6")
compare("missingdir"   , "Test 7")
compare("-Z"           , "Test 8")
compare("foo"          , "Test 9")

puts "You passed the tests, yay!"

