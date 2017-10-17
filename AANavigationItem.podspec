Pod::Spec.new do |s|
  s.name             = 'AANavigationItem'
  s.version          = '0.1.0'
  s.summary          = 'AANavigationItem - custom color, size and subviews per item in UINavigationController.'

  s.description      = <<-DESC
  Simple changing color UINavigationBar! 
  Just select it in AANavigationItem and run. Additionaly you can increase size of bar and add subviews.
  All are animatable and support interaction transiotions.
                       DESC

  s.homepage         = 'https://github.com/oboupo/AANavigationItem'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Anton Spivak' => 'oboupo@gmail.com' }
  s.source           = { :git => 'https://github.com/oboupo/AANavigationItem.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/oboupo'

  s.ios.deployment_target = '8.0'

  s.source_files          = 'AANavigationItem/Classes/**/*'
  s.private_header_files  = 'AANavigationItem/Classes/Private/**/*.h'
  s.frameworks            = 'UIKit'
end
