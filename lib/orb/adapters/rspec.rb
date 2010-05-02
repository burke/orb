### ORB RSpec Adapter
# This integrates ORB with RSpec. To run your test suite with ORB enabled,
# run `spec` with `-rorb`, or add `-rorb` to `spec_opts`, or simply 
# `require 'orb'` in your `spec_helper.rb`.

# ORB's requirements of an adapter are minimal:

# - (optional) Some convenient way to start an ORB session. 
# - (optional) A header describing this specific instance.
# Each RSpec example has a description that's printed when it fails.
# We re-create that here to provide context when an ORB session is started.
class ORB
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

# Initially, I wanted to override `pending` as the method to start ORB,
# but as it turns out, the Object hackery I need to do to make ORB work
# requires a block. Requiring that pending be called with a block seems like
# an odd design choice, so instead I've made the method ORB, 
# called like `ORB{}`.
module Spec
  module Example
    module Pending
      def ORB(&block)
        ORB.new(block.binding)
      end 
    end 
  end 
end 

# Finally, now that the RSpec Adapter is defined, set ORB's default Adapter.
ORB::Adapter = ORB::Adapters::RSpec
