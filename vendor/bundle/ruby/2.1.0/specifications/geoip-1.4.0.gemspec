# -*- encoding: utf-8 -*-
# stub: geoip 1.4.0 ruby lib

Gem::Specification.new do |s|
  s.name = "geoip"
  s.version = "1.4.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Clifford Heath", "Roland Moriz"]
  s.date = "2014-03-26"
  s.description = "GeoIP searches a GeoIP database for a given host or IP address, and\nreturns information about the country where the IP address is allocated,\nand the city, ISP and other information, if you have that database version."
  s.email = ["clifford.heath@gmail.com", "rmoriz@gmail.com"]
  s.executables = ["geoip"]
  s.extra_rdoc_files = ["LICENSE", "README.rdoc"]
  s.files = ["LICENSE", "README.rdoc", "bin/geoip"]
  s.homepage = "http://github.com/cjheath/geoip"
  s.licenses = ["LGPL"]
  s.rubygems_version = "2.4.2"
  s.summary = "GeoIP searches a GeoIP database for a given host or IP address, and returns information about the country where the IP address is allocated, and the city, ISP and other information, if you have that database version."

  s.installed_by_version = "2.4.2" if s.respond_to? :installed_by_version
end
