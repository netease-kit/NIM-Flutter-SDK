#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint nim_core.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'nim_core'
  s.version          = '1.4.7'
  s.summary          = 'A Flutter plugin for NetEase IM SDK on Android and iOS.'
  s.description      = <<-DESC
A Flutter plugin for NetEase IM SDK on Android and iOS.
                       DESC
  s.homepage         = 'https://meeting.163.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'NetEase, Inc.' => 'cyn0544@corp.netease.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.dependency 'NIMSDK_LITE/FCS', '~> 9.15.0'
  s.dependency 'YXAlog'
  s.platform = :ios, '11.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = {
            'DEFINES_MODULE' => 'YES',
            'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64'
      }
      s.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
  s.swift_version = '5.0'
end
