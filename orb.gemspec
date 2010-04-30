Gem::Specification.new do |gem|
  gem.name    = 'orb'
  gem.version = "0.0.1"

  gem.author, gem.email = 'Burke Libbey', "burke@burkelibbey.org"

  gem.summary     = "Interactive Testing"
  gem.description = "Description pending. Also does not work yet. Just want to save the name on rubygems.org..."

  # gem.required_ruby_version = '>= 1.8.7'

 gem.has_rdoc = false

  gem.files = %w[
    LICENSE
    README.md
    lib
    orb.gemspec
  ] + Dir["**/*.rb"]
end
