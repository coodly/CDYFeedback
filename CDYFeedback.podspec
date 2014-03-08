Pod::Spec.new do |spec|
  spec.name         = 'CDYFeedback'
  spec.version      = '0.1.0'
  spec.summary      = "Utility classes for user feedback."
  spec.homepage     = "https://github.com/coodly/CDYFeedback"
  spec.author       = { "Jaanus Siim" => "jaanus@coodly.com" }
  spec.source       = { :git => "https://github.com/coodly/CDYFeedback.git", :tag => "v#{spec.version}" }
  spec.license      = { :type => 'Apache 2', :file => 'LICENSE.txt' }
  spec.requires_arc = true

  spec.subspec 'Core' do |ss|
    ss.platform = :ios, '7.0'
    ss.source_files = 'Core/*.{h,m}'
    ss.framework = 'MessageUI'
  end
end
