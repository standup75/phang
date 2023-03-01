MY_USERNAME="sduprey"
PROJHOME="/Users/${MY_USERNAME}/Code/phang/tablet"
PROJDIR="${PROJHOME}/phonegap/platforms/ios"
APPLICATION_NAME="phang"
# compile project
echo Building Project
echo
echo Check that you updated config/config.xml with the latest version
echo Check you installed the latest provisioning
echo
cd ${PROJDIR}
mkdir ../../../build
open phang.xcodeproj
sleep 10
xcodebuild archive -project phang.xcodeproj -scheme phang -archivePath phang.xcarchive
xcodebuild -exportArchive -archivePath phang.xcarchive -exportPath ../../../build/phang -exportFormat ipa -exportProvisioningProfile "phang_tablet"
cd ../../..
