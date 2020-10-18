# Uncomment the next line to define a global platform for your project
# platform :ios, '10.0'


inhibit_all_warnings!



target 'musicSheet' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for musicSheet
   

  pod 'RxSwift', '~> 5'
  pod 'RxCocoa', '~> 5'
  pod 'NSObject+Rx'
  
  
  
  pod 'SnapKit', '~> 5.0.0'
  
  
  
  post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['LD_NO_PIE'] = 'NO'
        if config.name == 'Debug'
          config.build_settings['OTHER_SWIFT_FLAGS'] = ['$(inherited)', '-Onone']
          config.build_settings['SWIFT_OPTIMIZATION_LEVEL'] = '-Owholemodule'
        end
      end
    end
  end
  
  

  
end
