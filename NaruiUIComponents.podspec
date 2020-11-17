#
# Be sure to run `pod lib lint NaruiUIComponents.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'NaruiUIComponents'
  s.version          = '0.1.24'
  s.summary          = 'Narui UI Components for iOS'
  s.description      = '나루아이 UI컴포넌트 라이브러리. UI 컴포넌트 개발 및 사용 편의를 위해 만든 라이브러리 입니다.'
  s.homepage         = 'https://github.com/naruint/NaruiUIComponent'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '서창열' => 'kongbaguni@gmail.com' }
  s.source           = { :git => 'https://github.com/naruint/NaruiUIComponent.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/kongbaguni'
  s.ios.deployment_target = '12.0'
  s.source_files = 'NaruiUIComponents/Classes/*/*'
  s.resources = 'NaruiUIComponents/Assets/*.{xib,storyboard,xcassets}'
#  s.resource_bundles = {
#      'NaruiUIComponents' => ['NaruiUIComponents/Assets/*.{xib,storyboard,xcassets}']      
#  }
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
  s.dependency 'RxSwift'
  s.dependency 'RxCocoa'
  s.dependency 'UBottomSheet'
  s.dependency 'PhoneNumberKit'

end
