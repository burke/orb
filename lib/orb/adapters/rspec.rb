require 'spec/example/pending'

module ORB
  module Adapters
    module RSpec
      def self.header(bind)
        this = bind.eval("self")
        ancestry = [this.class, this]
        ancestry.map(&:description).join(" ")
      end 
    end 
  end 
end 

module Spec
  module Example
    module Pending
      def ORB(&block)
        ORB.capture(block.binding)
      end 
    end 
  end 
end 

ORB::Adapter = ORB::Adapters::RSpec
