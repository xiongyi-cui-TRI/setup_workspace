# install vendor library

# install python watchdog
# used in watch read roslauch config file program
sudo pip install watchdog

# install clang
(

sudo apt-get install -y clang-3.8 clang-format-3.8 

# to make Adress Sanitizer print line number
# http://stackoverflow.com/questions/38079761/why-does-asan-symbolizer-path-no-longer-work-with-version-adorned-binaries
exportPath 'export ASAN_SYMBOLIZER_PATH=/usr/bin/llvm-symbolizer-3.8'
sudo ln -s /usr/bin/llvm-symbolizer-3.8 /usr/bin/llvm-symbolizer

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
git checkout origin/rd_customize
cd rlog
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