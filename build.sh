#!/bin/bash

# machine's architecture
export ARCH=x86_64
echo "Machine's architecture: $ARCH"

# get the missing tools if necessary
if [ ! -f appimagetool-$ARCH.AppImage ]
  then
      echo "Get the missing tools..."
      curl -L -o appimagetool-$ARCH.AppImage \
      https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-$ARCH.AppImage
      chmod a+x appimagetool-$ARCH.AppImage
fi

# prepare source AppDir
rm -rf src
# TAR_FILE="$(ls -1|grep "tarantool-enterprise-bundle.*-linux-$ARCH.tar.gz")"
TAR_FILE="$(ls -1|grep "tarantool-enterprise-bundle.*.tar.gz")"
if [ -f "$TAR_FILE" ]
  then
      echo "Prepare source AppDir..."
      tar -xvf "$TAR_FILE"
      mv tarantool-enterprise src
      cp -vf bashrc src/
      cp -vf com.tarantool.io.png src/
      cp -vf com.tarantool.io.desktop src/
      cp -vf AppRun src/
      chmod a+x src/AppRun
      (cd src && ln -sf com.tarantool.io.png .DirIcon)
      cp -rvf usr src/
  else
      echo "Tarantool Enterprise Bundle not found!"
fi

# build AppImage
if [[ -f appimagetool-$ARCH.AppImage && -d src ]]
  then
      echo "Building AppImage..."
      rm -rvf build && mkdir build
      (cd build && ../appimagetool-$ARCH.AppImage ../src
      mv "Tarantool_EE_SDK-$ARCH.AppImage" "$(echo "$TAR_FILE"|\
      sed 's/tarantool-enterprise-bundle/Tarantool_EE_SDK/;s/tar.gz$/AppImage/')")
      rm -rf src
fi
