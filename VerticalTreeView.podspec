Pod::Spec.new do |s|
  s.name             = 'VerticalTreeView'
  s.version          = '0.1.0'
  s.summary          = 'Vertical drawing the TreeView'
  s.description      = <<-DESC
  Provides a vertical drawing of the tree structure and view information about the tree‘s nodes
                       DESC

  s.homepage         = 'https://github.com/ZhipingYang/VerticalTreeView'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Daniel Yang' => 'xcodeyang@gmail.com' }
  s.platform         = :ios, '8.0'
  s.source           = { :git => 'https://github.com/ZhipingYang/VerticalTreeView.git', :tag => s.version.to_s }
  s.requires_arc     = true

  s.swift_version = '5.0'
  s.ios.deployment_target = '10.0'
  s.source_files = 'class/*.swift'
  
end
