def Binding.of_caller(&block)
  old_critical, Thread.critical = Thread.critical, true
  count = 0
  cc = nil
  result, error = callcc{|c|cc=c}
  error.call if error
  
  tracer = lambda do |*args|
    type, _, _, _, context = args
    if ["return", "c-return"].include?(type)
      count += 1
      # First this method and then calling one will return -- the trace event of the second event gets the context
      # of the method which called the method that called method.
      if count == 2
        set_trace_func(nil)
        cc.call(eval("binding", context), nil)
      end
    elsif type != "line"
      set_trace_func(nil)
      cc.call(nil, lambda { raise(Exception, "Binding.of_caller used in non-method context or trailing statements of method using it aren't in the block." ) })
    end
  end
  
  if result
    Thread.critical = old_critical
    yield result
  else
    set_trace_func(tracer)
    return nil
  end
end

