#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint share_facebook_callback.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'share_facebook_callback'
  s.version          = '1.0.3'
  s.summary          = 'share_facebook_callback plugin.'
  s.description      = <<-DESC
share_facebook_callback plugin
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.dependency 'FBSDKShareKit', '~> 17.0.2'
  s.platform = :ios, '12.0'

  # Flutter.framework does contain a  x86_64 i386 arm64 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'VALID_ARCHS[sdk=iphonesimulator*]' => 'i386 arm64' }
  # s.pod_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
  # s.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
  s.swift_version = '5.0'
  s.ios.deployment_target = '12.0'
end
