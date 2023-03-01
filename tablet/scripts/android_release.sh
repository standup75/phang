MY_USERNAME="sduprey"
PROJHOME="/Users/${MY_USERNAME}/Code/phang/tablet"
PROJDIR="${PROJHOME}/phonegap/platforms/android"
cd ${PROJDIR}
echo --- building unsigned apk file ---
mkdir ../../../build
android update project -p . -s
ant release
echo --- signing apk file ---
jarsigner -verbose -sigalg SHA1withRSA -digestalg SHA1 -keystore ~/.android/release.keystore -storepass pipoman bin/CordovaApp-release-unsigned.apk android_release
jarsigner -verify -verbose -certs bin/CordovaApp-release-unsigned.apk
echo --- zipaligning apk file ---
~/bin/android-sdk-macosx/build-tools/20.0.0/zipalign -v 4 bin/CordovaApp-release-unsigned.apk bin/CordovaApp-release.apk
echo --- copy apk file ---
cp bin/CordovaApp-release.apk ../../../build/phang.apk
cd ../../..