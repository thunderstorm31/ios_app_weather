source 'https://cdn.cocoapods.org/'

platform :ios, '13.0'
inhibit_all_warnings!
use_frameworks!


install! 'cocoapods',
:generate_multiple_pod_projects => true,
:incremental_installation => true

workspace 'Weather'

target 'Weather' do
    pod 'SwiftLint'
        
    target 'WeatherTests' do
        inherit! :search_paths
    end
end
