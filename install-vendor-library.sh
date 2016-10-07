# install vendor library

# install gtest
cd
mkdir -p ~/library/rdlib
cd ~/library
git clone https://github.com/google/googletest
cd googletest/
mkdir build
cd build
cmake .. -DBUILD_SHARED_LIBS=ON -DCMAKE_INSTALL_PREFIX=${RD_LIB_VENDOR_PATH} -DCMAKE_BUILD_TYPE=Release
make -j7
make install

# install log
cd ~/library
git clone git@github.com:RedDragon-Tech/rlog.git
cd rlog
mkdir build
cd build
cmake .. -DBUILD_SHARED_LIBS=ON -DCMAKE_INSTALL_PREFIX=${RD_LIB_VENDOR_PATH} -DCMAKE_BUILD_TYPE=Release
make -j7
make install

# install fakeit mock
cd ~/library 
git clone https://github.com/eranpeer/FakeIt.git
cd FakeIt
cp single_header/gtest/fakeit.hpp $RD_LIB_VENDOR_PATH/include/
