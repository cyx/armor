# encoding: utf-8

Gem::Specification.new do |s|
  s.name = "armor"
  s.version = "0.0.3"
  s.summary = "shield's partner in crime."
  s.description = "A PBKDF2 pure ruby implementation."
  s.authors = ["Cyril David", "Michel Martens"]
  s.email = ["cyx@cyx.is", "michel@soveran.com"]
  s.homepage = "http://github.com/cyx/armor"
  s.files = Dir[
    "README*",
    "LICENSE",
    "makefile",
    "lib/*.rb",
    "tests/*.rb",
    "bin/*"
  ]
  s.license = "MIT"
end
