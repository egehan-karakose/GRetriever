#
# Be sure to run `pod lib lint GRetriever.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'GRetriever'
  s.version          = '0.1.1'
  s.summary          = 'GRetriever makes API call easy way.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

s.description      = <<-DESC
"GRetriever is a framework that allows to make API call with most simplest way."
                     DESC

  s.homepage         = 'https://github.com/egehan-karakose/GRetriever'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'egehan-karakose' => 'egehankarakose@gmail.com.tr' }
  s.source           = { :git => 'https://github.com/egehan-karakose/GRetriever.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'

  s.source_files = 'GRetriever/Classes/**/*'
  s.swift_version = '5.0'
  s.platforms = { "ios": "12.0" }
  
  # s.resource_bundles = {
  #   'GRetriever' => ['GRetriever/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
