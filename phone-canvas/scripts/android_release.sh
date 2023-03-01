cd ../phonegap/platforms/android
echo --- building unsigned apk file ---
android update project -p . -s
ant release
echo --- signing apk file ---
jarsigner -verbose -sigalg SHA1withRSA -digestalg SHA1 -keystore ~/.android/release.keystore -storepass pipoman bin/MainActivity-release-unsigned.apk android_release
jarsigner -verify -verbose -certs bin/MainActivity-release-unsigned.apk
echo --- zipaligning apk file ---
~/bin/android-sdk-macosx/build-tools/21.1.2/zipalign -v 4 bin/MainActivity-release-unsigned.apk bin/MainActivity-release.apk
echo --- copy apk file ---
cp bin/MainActivity-release.apk ../../../build/$1.apk
cd ../../..