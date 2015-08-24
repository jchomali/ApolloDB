Pod::Spec.new do |s|

  s.name                = "ApolloDB"
  s.version             = "0.0.1"
  s.summary             = "A secure and easy to implement database for your apps."
  s.homepage            = "https://github.com/jchomali/ApolloDB"
  s.license             = "MIT"
  s.author              = { "Juan Chomali" => "juan@jchomali.com" }
  s.social_media_url    = "http://twitter.com/JChomali"
  s.platform            = :ios, "6.0"
  s.ios.deployment_target = '6.0'
  s.source              = { :git => "https://github.com/jchomali/ApolloDB.git", :tag => s.version }
  s.framework           = "JavaScriptCore"
  s.requires_arc        = true
  s.source_files        = 'ApolloDB/ApolloDB.h'

end  