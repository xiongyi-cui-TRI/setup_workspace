

#sudo apt-get install -y ros-indigo-libg2o

# Install Eigen3
tar -zxvf Eigen3.2.8.tar.gz
cd Eigen3.2.8/
mkdir build
cd build
cmake ..
# CMAKE_INSTALL_PREFIX: /usr/local
sudo make install
cd ..
cd ..
# Now in library/ folder


# Install Yaml-cpp
tar -zxvf yaml-cpp-master.tar.gz 
cd yaml-cpp-master/
mkdir build
cd build
cmake -DBUILD_SHARED_LIBS=ON ..
# CMAKE_INSTALL_PREFIX: /usr/local
sudo make install
cd ..
cd ..
# Now in library/ folder



# Install openrave
#tar -zxvf openrave.tar.gz 
git clone https://github.com/rdiankov/openrave
cd openrave/
git checkout 9efdc1c777
mkdir build
cd build
cmake -DCMAKE_BUILD_TYPE=Release ..
# CMAKE_INSTALL_PREFIX: /usr/local
sudo make install
cd ..
cd ..

# Install 
#tar -zxvf libQGLViewer-2.6.3.tar.gz 
#cd libQGLViewer-2.6.3/QGLViewer
#qmake
# CMAKE_INSTALL_PREFIX: /usr/local
#sudo make install
#cd ..
#cd ..


# Install g2o
sudo apt-get install -y libqglviewer-dev
sudo apt-get install -y libsuitesparse-dev
tar -zxvf g2o-master.tar.gz 
cd g2o-master/
mkdir build
cd build
cmake -DCMAKE_BUILD_TYPE=Release QGLVIEWER_LIBRARY_RELEASE=/usr/lib/x86_64-linux-gnu/libQGLViewer.so ..
# CMAKE_INSTALL_PREFIX: /usr/local
sudo make install
cd ..
cd ..


