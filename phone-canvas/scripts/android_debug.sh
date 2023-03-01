cd ../phonegap/platforms/android
android update project -p . -s
ant debug
echo --- copy apk file ---
cp bin/CordovaApp-debug.apk ../../../build/$1.apk
cd ../../..