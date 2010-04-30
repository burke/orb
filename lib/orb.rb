require 'readline'

# TODO: load rspec or something.

module Spec
  module Example
    module Pending
      # alias __orb_original_pending pending
      def pending(message = "TODO")
        Binding.of_caller do |b|
          buf, line, last = [], "", ""
          
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
                ctx = bind.eval("self")
                ret = ctx.send(:eval, line, ctx.send(:binding))
              rescue => e
                puts e.message
              else 
                puts ret.inspect
              end 
            end 
            
            last = line
          end 
        end       
      end 
    end 
  end 
end 

module ORB

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
