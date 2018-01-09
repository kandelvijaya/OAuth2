# coding: utf-8
#

Pod::Spec.new do |s|

  s.name         = "OAuth2"
  s.version      = "0.3.1"
  s.summary      = "OAuth2 facilitates API interaction with simple Config"

  s.description  = <<-DESC
                   This library is handy if one wants to do OAuth2 based REST API usage. 
                   The only requirement for the library to enable OAuth2 is the config
                   file composed of
                   - tokenServerURL
                   - authServerURL
                   - scopes
                   - client_id

                   DESC

  s.homepage     = "https://github.com/kandelvijaya/OAuth2.git"
  s.license      = "MIT"

  s.author             = { "kandelvijaya" => "kandelvijaya@gmail.com" }
  s.social_media_url   = "http://twitter.com/kandelvijaya"

  s.platform     = :ios, "9.0"
  s.source       = { :git => "https://github.com/kandelvijaya/OAuth2.git", :tag => "#{s.version}" }

  s.source_files  = 'OAuth2/**/*.{swift,h,m,modulemap}'
  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '4' }

  s.dependency "Kekka", "~> 0.6"

end
