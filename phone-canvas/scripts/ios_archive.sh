# compile project
echo Building Project
echo
echo Check that you updated config/config.xml with the latest version
echo
PROJDIR="../phonegap/platforms/ios"
cd ${PROJDIR}

#Grabs info from plist
plist=$PROJDIR"/lovelooks/lovelooks-Info.plist"

#And changes it before writing out the plist again
/usr/libexec/PlistBuddy -c "Delete :UISupportedInterfaceOrientations~ipad array" "$plist"
/usr/libexec/PlistBuddy -c "Add :UISupportedInterfaceOrientations~ipad array" "$plist"
/usr/libexec/PlistBuddy -c "Add :UISupportedInterfaceOrientations~ipad:0 string \"UIInterfaceOrientationLandscapeLeft\"" "$plist"
/usr/libexec/PlistBuddy -c "Add :UISupportedInterfaceOrientations~ipad:1 string \"UIInterfaceOrientationLandscapeRight\"" "$plist"
/usr/libexec/PlistBuddy -c "Delete :UISupportedInterfaceOrientations array" "$plist"
/usr/libexec/PlistBuddy -c "Add :UISupportedInterfaceOrientations array" "$plist"
/usr/libexec/PlistBuddy -c "Add :UISupportedInterfaceOrientations:0 string \"UIInterfaceOrientationPortrait\"" "$plist"

/usr/libexec/PlistBuddy -c "Add :UIStatusBarHidden~ipad bool" "$plist"
/usr/libexec/PlistBuddy -c "Set :UIStatusBarHidden~ipad true" "$plist"

/usr/libexec/PlistBuddy -c "Add :UIStatusBarHidden~iphone bool" "$plist"
/usr/libexec/PlistBuddy -c "Set :UIStatusBarHidden~iphone true" "$plist"

open $1.xcodeproj
sleep 10
xcodebuild archive -project $1.xcodeproj -scheme $1 -archivePath $1.xcarchive
xcodebuild -exportArchive -archivePath $1.xcarchive -exportPath ../../../build/$1 -exportFormat ipa -exportProvisioningProfile "phang_distribution"
cd ../../..
