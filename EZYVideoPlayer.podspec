#
# Be sure to run `pod lib lint EZYVideoPlayer.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'EZYVideoPlayer'
  s.version          = '0.2.2'
  s.summary          = 'EZYVideoPlayer helps you to create a HLS video player without writing a single line of code.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  `EZYVideoPlayer will do all the heavy lifting that we required to create the HLS video player. It has all the basic and advanced functionality that a modern video player has. Just drag and drop UIView and inhirite it from EZYVideoPlayer this is all that we need to do.`
                       DESC

  s.homepage         = 'https://github.com/shashankpali/EZYVideoPlayer'
   s.screenshots     = 'https://user-images.githubusercontent.com/11850361/203582368-0cd2c369-3408-4e47-b859-9364ffbc030d.png'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Shashank Pali' => 'shank.pali@gmail.com' }
  s.source           = { :git => 'https://github.com/shashankpali/EZYVideoPlayer.git', :tag => s.version }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '14.0'
  s.swift_version = '5.0'
  s.source_files = 'EZYVideoPlayer/Classes/**/*'
  
  
  # s.resource_bundles = {
  #   'EZYVideoPlayer' => ['EZYVideoPlayer/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
