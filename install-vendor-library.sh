# install vendor library

# install python watchdog
# used in watch read roslauch config file program
sudo pip install watchdog

# install clang
(
# clang
clangVERSION="4.0"
echo installing clang-${clangVERSION}
srcDir="/etc/apt/sources.list.d/clang"
sudo rm -rf ${srcDir}
sudo mkdir -p ${srcDir}
sudo echo "deb http://apt.llvm.org/trusty/ llvm-toolchain-trusty-${clangVERSION} main
deb-src http://apt.llvm.org/trusty/ llvm-toolchain-trusty-${clangVERSION} main" \
| sudo tee --append ${srcDir}/clang.list > /dev/null
sudo apt-get update

sudo apt-get install -y clang-${clangVERSION} clang-format-${clangVERSION} \
 libfuzzer-${clangVERSION}-dev


sudo rm -rf /usr/bin/llvm-symbolizer

# to make Adress Sanitizer print line number
# http://stackoverflow.com/questions/38079761/why-does-asan-symbolizer-path-no-longer-work-with-version-adorned-binaries
exportPath 'export ASAN_SYMBOLIZER_PATH=/usr/bin/llvm-symbolizer'
sudo ln -s /usr/bin/llvm-symbolizer-${clangVERSION} /usr/bin/llvm-symbolizer


	)
# install gtest
cd $RD_LIB_PATH

( # start in $RD_LIB_PATH
cd $RD_LIB_PATH
git clone https://github.com/google/googletest
cd googletest/
mkdir build
cd build
cmake .. -DBUILD_SHARED_LIBS=ON -DCMAKE_INSTALL_PREFIX=${RD_LIB_VENDOR_PATH} -DCMAKE_BUILD_TYPE=Release
make -j7
make install
)

# install log
( # start in $RD_LIB_PATH
mkdir -p /tmp/rdlogs/
cd ~/library
git clone git@github.com:RedDragon-Tech/rlog.git
cd rlog
git checkout origin/rd_customize
mkdir build
cd build
cmake .. -DBUILD_SHARED_LIBS=ON -DCMAKE_INSTALL_PREFIX=${RD_LIB_VENDOR_PATH} -DCMAKE_BUILD_TYPE=Release
make -j7
make install
)

# install fakeit mock
( # start in $RD_LIB_PATH
cd ~/library 
git clone https://github.com/eranpeer/FakeIt.git
cd FakeIt
cp single_header/gtest/fakeit.hpp $RD_LIB_VENDOR_PATH/include/
)