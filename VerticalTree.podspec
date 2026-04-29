Pod::Spec.new do |s|
  s.name = 'VerticalTree'
  s.version = '0.0.1'
  
  s.source = { 
    :git => "https://github.com/ZhipingYang/#{s.name}.git", 
    :tag => s.version.to_s
  }

  s.summary = 'A vertical tree view and console tree formatter for Swift.'
  s.description = 'VerticalTree renders tree-structured data as a foldable vertical list and provides debug-friendly tree formatting for UIKit objects, layers, controllers, and custom node models.'

  s.homepage         = "https://github.com/ZhipingYang/#{s.name}"
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Daniel Yang' => 'xcodeyang@gmail.com' }
  s.ios.deployment_target = '26.2'
  s.requires_arc     = true
  s.swift_versions   = ['6']

  s.default_subspecs = 'Core', 'UI', 'PrettyExtension'

  s.subspec 'Core' do |c|
    c.source_files = 'class/core/*.swift'
    c.frameworks = 'Foundation'
  end

  s.subspec 'UI' do |ui|
    ui.source_files = 'class/ui/*.swift'
    ui.frameworks = 'UIKit'
    ui.dependency 'VerticalTree/Core'
    ui.dependency 'Then'
  end

  s.subspec 'PrettyExtension' do |pt|
    pt.source_files = 'class/pretty/*.swift'
    pt.dependency 'VerticalTree/Core'
  end

end
