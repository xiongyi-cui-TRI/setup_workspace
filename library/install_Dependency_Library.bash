

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
# install openrave 0.9
#git clone https://github.com/rdiankov/openrave
#cd openrave/
#git checkout 9efdc1c777

# install 0.8.2
#git clone --branch latest_stable https://github.com/rdiankov/openrave.git
#cd openrave/

#mkdir build
#cd build
#cmake -DCMAKE_BUILD_TYPE=Release ..
#sudo make install
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
#sudo apt-get install -y libqglviewer-dev
#sudo apt-get install -y libsuitesparse-dev
#tar -zxvf g2o-master.tar.gz 
#cd g2o-master/
#mkdir build
#cd build
#cmake -DCMAKE_BUILD_TYPE=Release QGLVIEWER_LIBRARY_RELEASE=/usr/lib/x86_64-linux-gnu/libQGLViewer.so ..
# CMAKE_INSTALL_PREFIX: /usr/local
#sudo make install
#cd ..
#cd ..

# compile OpenCV
#sudo apt-get -y install libopencv-dev build-essential cmake git libgtk2.0-dev pkg-config python-dev python-numpy libdc1394-22 libdc1394-22-dev libjpeg-dev libpng12-dev libtiff4-dev libjasper-dev libavcodec-dev libavformat-dev libswscale-dev libxine-dev libgstreamer0.10-dev libgstreamer-plugins-base0.10-dev libv4l-dev libtbb-dev libqt4-dev libfaac-dev libmp3lame-dev libopencore-amrnb-dev libopencore-amrwb-dev libtheora-dev libvorbis-dev libxvidcore-dev x264 v4l-utils unzip

#tar -zxvf opencv-3.1.0.tar.gz
#cd opencv-3.1.0
#mkdir build
#cd build
#cmake -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=/usr/local -D WITH_TBB=ON -D WITH_V4L=ON -D WITH_QT=ON -D WITH_OPENGL=ON ..
#make
#sudo make install
#sudo /bin/bash -c 'echo "/usr/local/lib" > /etc/ld.so.conf.d/opencv.conf'
#sudo ldconfig


