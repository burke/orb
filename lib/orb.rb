require 'readline'
require 'orb/adapters/rspec'

module ORB
  
  def self.capture(bind)
    buf, line, last = [], "", ""

    puts ORB::Adapter.header(bind)
    
    while line = Readline.readline("ORB >> ", true)
      
      case line
      when "a"
        buf << last
        next
      when "p"
        puts buf
        next 
      when "q"
        __orb_original_pending(message)
        break
      when "s"
        line, file = bind.eval("[__LINE__, __FILE__]")
        ORB.write_buf_to_file(buf, line, file)
        break
      else 
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

  def self.write_buf_to_file(buf, line_num, file)
    lines = File.read(file).lines.to_a
     
    File.open(file,"w") do |f|
      f.puts lines[0...line_num-1]
     
      orbline = lines[line_num-1]
      indentation = orbline.index(/[^\s]/)
     
      buf.each do |bufline|
        f.print " "*indentation
        f.puts bufline
      end 
      
      f.puts lines[line_num..-1]
    end   
  end 
  
end 
