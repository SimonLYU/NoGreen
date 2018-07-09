platform :ios, '8.0'
use_frameworks!
inhibit_all_warnings!

project 'NoGreen'
target 'NoGreen' do
    pod 'AFNetworking', '~> 3.0'
    pod 'MJRefresh'
    pod 'SDWebImage'
    pod 'Masonry'
    pod 'ReactiveCocoa', :git => 'https://github.com/zhao0/ReactiveCocoa.git', :tag => '2.5.2'
    pod 'MJExtension'
    pod 'pop'
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        puts #{target.name}
    end
    
end
