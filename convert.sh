# prepare
mkdir out
rm -rf iphoneos
rm -rf iphonesimulator
rm -rf GoogleAnalytics.xcframework
rm GoogleAnalytics.xcframework.zip
mkdir -p iphoneos
mkdir -p iphonesimulator

# untar the package
wget https://www.gstatic.com/cpdc/5cd71dd2f756bb01/GoogleAnalytics-3.17.0.tar.gz
tar -xzf GoogleAnalytics-3.17.0.tar.gz --directory out
cp -f ./out/Libraries/libGoogleAnalytics.a ./GoogleAnalytics.framework/GoogleAnalytics
cp -fR ./out/Sources/*.h ./GoogleAnalytics.framework/Headers
cp ./Info.plist ./GoogleAnalytics.framework/Info.plist
cp ./GAI-Umbrella.h ./GoogleAnalytics.framework/Headers/GAI-Umbrella.h
cp -R ./GoogleAnalytics.framework ./iphoneos/GoogleAnalytics.framework
cp -R ./GoogleAnalytics.framework ./iphonesimulator/GoogleAnalytics.framework

# print the architectures
# armv7 armv7s i386 x86_64 arm64
xcrun lipo -i GoogleAnalytics.framework/GoogleAnalytics

# cleanup iphoneos framework
xcrun lipo -remove i386 -remove x86_64 ./iphoneos/GoogleAnalytics.framework/GoogleAnalytics -o ./iphoneos/GoogleAnalytics.framework/GoogleAnalytics
xcrun lipo -i iphoneos/GoogleAnalytics.framework/GoogleAnalytics

# cleanup simulator framework
xcrun lipo -remove arm64 -remove armv7 ./iphonesimulator/GoogleAnalytics.framework/GoogleAnalytics -o ./iphonesimulator/GoogleAnalytics.framework/GoogleAnalytics
xcrun lipo -i iphonesimulator/GoogleAnalytics.framework/GoogleAnalytics

# create xcframework
xcodebuild -create-xcframework \
  -framework iphoneos/GoogleAnalytics.framework/ \
  -framework iphonesimulator/GoogleAnalytics.framework/ \
  -output "GoogleAnalytics.xcframework"

# cleanup
rm -rf iphoneos
rm -rf iphonesimulator
rm GoogleAnalytics-3.17.0.tar.gz
rm -f ./GoogleAnalytics.framework/GoogleAnalytics
rm -rf ./GoogleAnalytics.framework/Headers/*.h
