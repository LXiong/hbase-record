Gem::Specification.new do |s|
  s.name        = 'hbase_record'
  s.version     = '0.0.15'
  s.date        = '2014-02-27'
  s.summary     = "Ruby ORM for Hbase!"
  s.description = ""
  s.authors     = ["Siwon Choi", "Jaeyeon Lee"]
  s.email     = ["red@zoyi.co"]
  s.homepage    = ""

  s.add_dependency "thrift", '~> 0.9.1'
  s.add_dependency "thin", '~> 1.6.0'
  s.add_dependency "activesupport", '~> 4.0.0'


  s.files       = `git ls-files -- lib/hbase_record`.split("\n")
  s.license       = 'MIT'
end
