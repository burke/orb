Gem::Specification.new do |gem|
  gem.name    = 'orb'
  gem.version = "0.0.6"

  gem.author, gem.email = 'Burke Libbey', "burke@burkelibbey.org"

  gem.summary     = "ORB is a tool to write tests interactively"
  gem.description = "ORB is a tool to write tests interactively. Add ORB{} to one of your tests, then when you run your test suite, you'll get dropped to a REPL, where you can explore the test's context and build an implementation for the test, before automatically writing it out to the file and replacing the ORB{} call."

gem.has_rdoc = false

  gem.files = %w[
    LICENSE
    README.md
    lib
    orb.gemspec
  ] + Dir["**/*.rb"]
end
