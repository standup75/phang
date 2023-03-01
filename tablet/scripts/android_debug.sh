MY_USERNAME="sduprey"
PROJHOME="/Users/${MY_USERNAME}/Code/phang/tablet"
PROJDIR="${PROJHOME}/phonegap/platforms/android"
cd ${PROJDIR}
mkdir ../../../build
android update project -p . -s
ant debug
echo --- copy apk file ---
cp bin/CordovaApp-debug.apk ../../../build/phang.apk
cd ../../..