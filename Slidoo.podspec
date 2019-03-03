#
# Be sure to run `pod lib lint Slidoo.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Slidoo'
  s.version          = '1.0.3'
  s.summary          = 'Navigation Drawer implemented with Swift'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description = "This is iOS equivalent of Android's Navigation Drawer"

  s.homepage         = 'https://github.com/mitulmanish/Slidoo.git'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'mitul_manish' => 'mitul.manish@gmail.com' }
  s.source           = { :git => 'https://github.com/mitulmanish/Slidoo.git', :tag => s.version.to_s }
  s.ios.deployment_target = '9.0'
  s.source_files = 'Slidoo/Classes/**/*'
  s.swift_version = '4.2'
end
