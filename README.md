# weatherapp
owm weather app

items done:
- git
- cocoapods
- alamofire
- reachability obj c file added - with bridging header
- service manager, utility, constants
- mvc pattern
- using Google Places API for city search - not using openweather site's city list - it does not contain state info for cities with same names (eg.Allentown) - results may still be inaccurate - i could not find filtering with city & state name
- asset catalog, storyboard, launch screen, app icons set
- ATS Disabled for OWM API
- last searched city automatically load - recent searches
- automated test cases - only unit tests added - UI tests ignored for time being
- comments - complete or incomplete items - please search for "//Comments :" in the project

items not done:
- handling api response error codes in successful service completion - not sure about all fail codes
- encrypting saved data - AES256 - no time
- image cache using KingFisher lib - no time
- mask UI when app goes background - protect sensitive data - no time
- iPad specific UI - no time
- unit conversions - metric/imperial - C/F - local timestamp
