Pod::Spec.new do |s|
    s.name          = "jive-ios-sdk"
    s.version       = "0.5.5"
    s.license       = { :type => "Apache License, Version 2.0", :file => "README.md" }
    s.summary       = "iOS SDK for the Jive REST API."
    s.homepage      = "https://github.com/jivesoftware/jive-ios-sdk"
    s.authors       = { "Jive Mobile" => "jive-mobile@jivesoftware.com" }
    s.source_files  = "jive-ios-sdk/JiveiOSSDKVersion.h","jive-ios-sdk/**/*.{h,m}","lib/JiveObjcRuntime.{h,m}","lib/google-toolbox-for-mac/Foundation/*.{h,m}"
    s.frameworks    = "Foundation", "MobileCoreServices", "SystemConfiguration"
    s.source        = { :git => "git@git.jiveland.com:jive-ios-sdk", :tag => "v#{s.version}" }
    s.requires_arc  = true
    s.platform      = :ios
    s.ios.deployment_target = "6.0"
    s.header_dir    = "Jive"
    s.public_header_files = "jive-ios-sdk/**/*.{h},lib/google-toolbox-for-mac/Foundation/*.{h}"
    s.private_header_files = "jive-ios-sdk/JiveKVOAdapter.h","jive-ios-sdk/NSDateFormatter+JiveISO8601DateFormatter.h","jive-ios-sdk/JiveRetryingURLConnectionOperation.h","jive-ios-sdk/JiveRetryingInner*.h","jive-ios-sdk/entity/JiveTargetList_internal.h","jive-ios-sdk/entity/JiveTypedObject_internal.h","jive-ios-sdk/JAPIRequestOperation.h","jive-ios-sdk/JiveRetrying*HTTPRequestOperation.h","jive-ios-sdk/JiveRetrying*APIRequestOperation.h","jive-ios-sdk/JiveRetryingURLConnectionOperation*.h"
    s.prefix_header_file = "jive-ios-sdk/jive-ios-sdk-Prefix.pch"
    s.dependency    "AFNetworking", "1.2.1"
    s.dependency    "hpple", "~> 0.2.0"

    # Disable arc
    s.subspec "no-arc" do |na|
        na.source_files = "lib/NSData+JiveBase64.{h,m}"
        na.requires_arc = false
    end
    
    # call update-JiveiOSSDKVersion.bash with the pod's version number
    s.prepare_command = <<-CMD
        ./jive-ios-sdk/update-JiveiOSSDKVersion.bash #{s.version}
    CMD
end
