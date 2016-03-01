Pod::Spec.new do |s|
  s.name = "Horizon"
  s.version = "1.0.1"
  s.summary = "Horizon lets you find out if a host truly is reachable"
  s.homepage = "https://github.com/pisarm/Horizon"
  s.license = { :type => "MIT", :file => "LICENSE" }
  s.author = { "Flemming Pedersen" => "flemming@pisarm.dk" }

  s.ios.deployment_target = "8.0"
  s.osx.deployment_target = "10.10"
  s.watchos.deployment_target = "2.1"
  s.tvos.deployment_target = "9.0"

  s.source = { :git => "https://github.com/pisarm/Horizon.git", :tag => s.version }
  s.source_files  = "Sources", "Sources/**/*.swift"
end
