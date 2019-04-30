Pod::Spec.new do |s|
  s.name             = 'VerticalTree'
  s.version          = '0.2.1'
  s.summary          = 'Vertical drawing the TreeView'
  s.description      = <<-DESC
  Provides a vertical drawing of the tree structure and view information about the tree‘s nodes
                       DESC

  s.homepage         = 'https://github.com/ZhipingYang/VerticalTree'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Daniel Yang' => 'xcodeyang@gmail.com' }
  s.platform         = :ios, '9.0'
  s.source           = { :git => 'https://github.com/ZhipingYang/VerticalTree.git', :tag => s.version.to_s }
  s.requires_arc     = true
  s.swift_version = '5.0'
  s.ios.deployment_target = '9.0'

  s.default_subspecs = 'Core', 'UI', 'PrettyExtension'

  s.subspec 'Core' do |c|
      c.source_files = 'class/core/*.swift'
	  s.framework = "Foundation"
  end

  s.subspec 'UI' do |ui|
      ui.source_files = 'class/ui/*.swift'
      ui.ios.framework = "UIKit"
      ui.dependency 'VerticalTree/Core'
      ui.dependency 'Then'
  end

  s.subspec 'PrettyExtension' do |pt|
      pt.source_files = 'class/pretty/*.swift'
      pt.dependency 'VerticalTree/Core'
  end

end
