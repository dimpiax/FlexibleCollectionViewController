#
# Be sure to run `pod lib lint FlexibleCollectionViewController.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'FlexibleCollectionViewController'
  s.version          = '1.0.4'
  s.summary          = 'Generic collection view controller with external data processing'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
Swift library of generic collection view controller with external data processing of functionality, like determine cell’s reuseIdentifier related to indexPath, configuration of requested cell for display and cell selection handler
                       DESC

  s.homepage         = 'https://github.com/dimpiax/FlexibleCollectionViewController'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Pilipenko Dima' => 'dimpiax@gmail.com' }
  s.source           = { :git => 'https://github.com/dimpiax/FlexibleCollectionViewController.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/dimpiax'

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.ios.deployment_target = '8.0'

  s.source_files = 'FlexibleCollectionViewController/Classes/**/*'
  
  # s.resource_bundles = {
  #   'FlexibleCollectionViewController' => ['FlexibleCollectionViewController/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
