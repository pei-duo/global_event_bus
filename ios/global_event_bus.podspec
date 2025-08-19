#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint global_event_bus.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'global_event_bus'
  s.version          = '0.0.6'  # 需要更新版本号
  s.summary          = 'A high-performance, type-safe global event bus system for Flutter applications.'  # 需要更新描述
  s.description      = <<-DESC
A high-performance, type-safe global event bus system for Flutter applications with priority support, batch processing, and comprehensive logging.
                       DESC
  s.homepage         = 'https://gitee.com/peiduo_734386/global_event_bus'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Pedro Pei' => 'pedro.pei@icloud.com' }  # 需要更新作者信息
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '12.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'

  # If your plugin requires a privacy manifest, for example if it uses any
  # required reason APIs, update the PrivacyInfo.xcprivacy file to describe your
  # plugin's privacy impact, and then uncomment this line. For more information,
  # see https://developer.apple.com/documentation/bundleresources/privacy_manifest_files
  # s.resource_bundles = {'global_event_bus_privacy' => ['Resources/PrivacyInfo.xcprivacy']}
end
