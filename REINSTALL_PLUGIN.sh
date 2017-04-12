#!/bin/bash

rm -rf $HOME/qml-cvcamera/build-desktop
cd $HOME/qml-cvcamera
mkdir build-desktop
cd build-desktop
$HOME/Qt/5.8/gcc_64/bin/qmake ..
make -j 5
sudo make install

