# ORB is a tool to write tests interactively. 

# Most ruby programmers, even the ones with extensive test suites, frequently 
# find themselves in IRB, trying snippets of code here and there.
# It's not uncommon to run some code in IRB, then copy parts of it almost
# verbatim into a test file for use as a test. ORB makes this a much more smooth
# process. 

# The basic workflow with ORB is: 

# 1. Add `ORB{}` to each new test, at the point where you'd like to insert code.
# 2. Run your test suite with `orb` loaded. See `adapters/rspec.rb`.
# 3. Use the REPL provided for each call to ORB to create a new test.

# When a call to `ORB` is encountered, you'll be dropped to to a REPL with full
# access to the test's context (much like a debugger). You can run code, and 
# interact with the context however you like. When you're ready to write your 
# test, you simply run the commands, then add them to a buffer. Once your 
# buffer contains the code you'd like to save as a test, you can write
# it back to the file in place of the call to `ORB` with just two keystrokes.

# The REPL uses readline for line editing.
require 'readline'

# Adapters are near-trivial to write, and provide test-framework integration.
require 'orb/adapters/rspec'

class ORB
  @@index=0
  def initialize(bind)
    @@index += 1
    @buf, @hist, last = [], [], ""
    @line, @file = bind.eval("[__LINE__, __FILE__]")

    puts "\n\n[[ #{ORB::Adapter.header(bind)} ]]"
    
    while line = Readline.readline(prompt, true)
      case line
      when /^a\s?(\d*)$/
        @hist.last[1] = true
        @buf << last
        next

        # The `h` command shows this session's history. Each line starts with 
        # a coloured space. A red space indicates that this line is not in
        # the buffer, and a green space indicates that this line is in the 
        # buffer, and will be written back to the file when the test is saved.
      when "h"
        red   = "\x1B[41m \x1B[m"
        green = "\x1B[42m \x1B[m"
        @hist.each do |line, in_buf|
          print in_buf ? green : red
          print ' '
          puts line
        end 
        next 

        # The `p` command prints the current contents of the buffer. If the test
        # is written back to the file right now, this is what will be inserted.
      when "p"
        puts @buf
        next 
        
        # The `q` command exits this session without writing a test. Next time
        # the suite is run, you'll get a REPL here again.
      when "q"
        break
        
        # The `s` command writes the contents of the buffer out to the file.
      when "s"
        ORB.write_buf_to_file
        break
        
        # If this line wasn't a command, evaluate it in the context of the code 
        # that called `ORB{}`. We're stealing that context from the block.
        # There are other, trickier tricks to get it without requiring a block,
        # but they haven't been reliable since ruby 1.8.5.
      else 
        @hist << [line,false]
        begin
          this = bind.eval("self")
          ret = this.send(:eval, line, this.send(:binding))
        rescue => e
          puts e.message
        else 
          puts ret.inspect
        end 
      end 
      
      last = line
    end 
  end 

  private
  
  # When this command is run, ORB will save the contents of the test buffer
  # back into the file where `ORB{}` was called from. It does this by reading
  # in the entire file, then rewriting it with ORB{} replaced by the buffer.
  def write_buf_to_file
    lines = File.read(@file).lines.to_a
     
    File.open(@file,"w") do |f|
      f.puts lines[0...@line-1]
     
      orbline = lines[@line-1]
      indentation = orbline.index(/[^\s]/)

      # Here we're indenting the inserted code to the same level as `ORB{}` 
      # was indented.
      @buf.each do |bufline|
        f.print " "*indentation
        f.puts bufline
      end 
      
      f.puts lines[@line..-1]
    end   
  end 
  
  # ORB's prompt looks like `1:0 >>`. The first number is the index of this 
  # test, starting at one, and incrementing with each test during an 
  # ORB-enhanced run of your test suite. The second number is the current size 
  # of the test buffer; that is, the number of lines that will be written to 
  # the file if the test is saved right now.
  def prompt
    "#{@@index}:#{@buf.size} >> "
  end 

end 
