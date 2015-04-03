# -*- encoding: utf-8 -*-
# stub: authorize-net 1.5.2 ruby lib

Gem::Specification.new do |s|
  s.name = "authorize-net"
  s.version = "1.5.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Authorize.Net"]
  s.date = "2011-01-10"
  s.description = "  The Authorize.Net Ruby SDK is meant to offer an alternate object-oriented\n  model of development with the Authorize.net APIs (Version 3.1). The SDK is\n  based entirely off the name-value pair API, but performs the core payment\n  activities (such as error handling/parsing, network communication, and data\n  encoding) behind the scenes. Providing the end developer with this allows the\n  developer to start integrating immediately without having to write out a mass\n  of boiler plate code.\n"
  s.email = "developer@authorize.net"
  s.homepage = "http://www.authorize.net/"
  s.licenses = ["AUTHORIZE.NET SOFTWARE DEVELOPMENT KIT (SDK) LICENSE AGREEMENT"]
  s.rdoc_options = ["-U", "-S", "--main=README.rdoc", "README.rdoc"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.8.7")
  s.rubyforge_project = "authorize-net"
  s.rubygems_version = "2.4.2"
  s.summary = "Ruby API for communicating with Authorize.net via the AIM, ARB, CIM, SIM, DPM and Reporting APIs."

  s.installed_by_version = "2.4.2" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<nokogiri>, ["~> 1.4"])
      s.add_development_dependency(%q<rspec>, ["~> 1.3"])
      s.add_development_dependency(%q<ruby-debug>, ["~> 0.10"])
      s.add_development_dependency(%q<rdoc>, ["~> 1.0"])
      s.add_development_dependency(%q<rake>, ["~> 0.8"])
    else
      s.add_dependency(%q<nokogiri>, ["~> 1.4"])
      s.add_dependency(%q<rspec>, ["~> 1.3"])
      s.add_dependency(%q<ruby-debug>, ["~> 0.10"])
      s.add_dependency(%q<rdoc>, ["~> 1.0"])
      s.add_dependency(%q<rake>, ["~> 0.8"])
    end
  else
    s.add_dependency(%q<nokogiri>, ["~> 1.4"])
    s.add_dependency(%q<rspec>, ["~> 1.3"])
    s.add_dependency(%q<ruby-debug>, ["~> 0.10"])
    s.add_dependency(%q<rdoc>, ["~> 1.0"])
    s.add_dependency(%q<rake>, ["~> 0.8"])
  end
end
