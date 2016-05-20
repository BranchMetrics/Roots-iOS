Pod::Spec.new do |s|
  s.name             = "Roots"
  s.version          = "0.1.1"
  s.summary          = "An SDK for linking in-between apps."
  s.description      = <<-DESC
Roots is an open source deep linking SDK developed by Branch that promotes inter-app linking. It has functionality to help with linking on both sides: 1. the source (app where a link is clicked) and 2. the receiver (the app where a link is opened). For source apps, it leverages Facebook's App Links meta tags on the site to determine how to route the user. It attempts to open the app, but safely falls back to mobile web or the App Store depending on configuration. For receiving apps, the SDK makes it incredibly easy to map your App Links URI to a particular View Controller.
                       DESC

  s.homepage         = "https://github.com/BranchMetrics/Roots-iOS-SDK"
  s.license          = 'MIT'
  s.author           = { "Branch" => "support@branch.io" }
  s.source           = { :git => "https://github.com/BranchMetrics/Roots-iOS-SDK.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/branchmetrics'

  s.ios.deployment_target = '8.0'

  s.source_files = 'Roots-iOS-SDK/**/*'
  
end
