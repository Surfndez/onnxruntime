#!/bin/bash

# This is for testing GPU final jar on Linux
set -e -o -x

while getopts r:v: parameter_Option
do case "${parameter_Option}"
in
r) BINARY_DIR=${OPTARG};;
v) VERSION_NUMBER=${OPTARG};;
esac
done

EXIT_CODE=1

uname -a

mkdir test
echo "Directories created"
pushd test
jar xf $BINARY_DIR/final-jar/testing.jar
popd

LD_LIBRARY_PATH=./test:${LD_LIBRARY_PATH}
echo  "Library path:" $LD_LIBRARY_PATH
wget https://oss.sonatype.org/service/local/repositories/releases/content/org/junit/platform/junit-platform-console-standalone/1.6.2/junit-platform-console-standalone-1.6.2.jar -P ./
wget https://oss.sonatype.org/service/local/repositories/google-releases/content/com/google/protobuf/protobuf-java/3.9.2/protobuf-java-3.9.2.jar -P ./
java -jar ./junit-platform-console-standalone-1.6.2.jar -cp .:./test:./protobuf-java-3.9.2.jar:./onnxruntime-gpu-${VERSION_NUMBER}.jar --scan-class-path --fail-if-no-tests --disable-banner

EXIT_CODE=$?

set -e
exit $EXIT_CODE
