#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint nim_core_macos.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'nim_core_macos'
  s.module_name      = 'nim_core_macos'
  s.version          = '1.0.8'
  s.summary          = 'A Flutter plugin for NetEase IM SDK on Android, iOS, Windows and MacOS.'
  s.description      = <<-DESC
    A Flutter plugin for NetEase IM SDK on Android, iOS, Windows and MacOS.
                       DESC
  s.homepage         = 'https://meeting.163.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'NetEase, Inc.' => 'wangjianzhong@corp.netease.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*', 'log/**/*.h', 'nim_sdk/**/*.h'
  s.public_header_files = "Classes/nim_core_macos_plugin.h"
  s.dependency 'FlutterMacOS'
  s.platform = :osx, '10.14'
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', "HEADER_SEARCH_PATHS" => "${PODS_TARGET_SRCROOT}/Classes/ ${PODS_TARGET_SRCROOT}/nim_sdk/wrapper" }
  s.swift_version = '5.0'
  s.vendored_libraries = 'nim_sdk/**/*.a', 'nim_sdk/**/*.dylib'
  s.vendored_frameworks = 'log/**/*.framework', 'nim_sdk/**/*.framework'
  s.static_framework = true
  s.library = 'c++'
  s.xcconfig = {
       'CLANG_CXX_LANGUAGE_STANDARD' => 'c++17',
       'CLANG_CXX_LIBRARY' => 'libc++'
  }
  s.prepare_command = <<-CMD
    cd ../
    dart pub get
    python ./scripts/build.py
                      CMD
end
