# Uncomment the next line to define a global platform for your project
platform :ios, '9.0'

target 'SlothChat' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
  pod "Alamofire"
  pod "SwiftyJSON"
  pod "SnapKit"
  pod "PKHUD", :git => 'https://github.com/toyship/PKHUD.git'
  pod "AwesomeCache", :git => 'https://github.com/aschuch/AwesomeCache.git'
  pod "AlamofireObjectMapper"
  pod "RongCloudIM/IMKit"
  pod "SDWebImage"
  
  # Pods for SlothChat

  target 'SlothChatTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'SlothChatUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
        end
    end
end
