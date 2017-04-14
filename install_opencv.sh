# get exportPath function
# source ~/library/setup_workspace/library_Path.sh
cd ~/library


# ref https://www.scivision.co/anaconda-python-opencv3/
# http://www.pyimagesearch.com/2015/07/20/install-opencv-3-0-and-python-3-4-on-ubuntu/
# Clone OpenCV somewhere
# I'll put it into $HOME/code/opencv
OPENCV_DIR="$HOME/library/opencv"
OPENCV_CONTRIB_DIR="$HOME/library/opencv_contrib"
OPENCV_CONTRIB_MODULES_DIR="${OPENCV_CONTRIB_DIR}/modules/"
OPENCV_VER="3.2.0"
OPENCVPYTHON3_VENV="opencvpython3"
git clone https://github.com/opencv/opencv "$OPENCV_DIR"
git clone https://github.com/Itseez/opencv_contrib.git "$OPENCV_CONTRIB_DIR"
(cd "$OPENCV_CONTRIB_DIR"
git checkout "$OPENCV_VER")
(cd "$OPENCV_DIR"
git checkout "$OPENCV_VER")

# This'll take a while...

sudo apt install build-essential cmake git libgtk2.0-dev pkg-config libavcodec-dev libavformat-dev libswscale-dev
sudo apt-get install -y python-numpy python-scipy python-matplotlib ipython ipython-notebook python-pandas python-sympy python-nose
sudo apt install libtbb2 libtbb-dev libjpeg-dev libpng-dev libtiff-dev libjasper-dev libdc1394-22-dev
sudo apt-get install-y libavcodec-dev libavformat-dev libswscale-dev libv4l-dev libxvidcore-dev libx264-dev
sudo apt-get install -y libgtk3.0-dev
sudo apt-get install -y libatlas-base-dev gfortran


# Now lets checkout the specific version we want

# First OpenCV will generate the files needed to do the actual build.
# We'll put them in an output directory, in this case "release"
cd ${OPENCV_DIR}
rm -rf release
mkdir release
cd release

# Note: This is where you'd add build options, like TBB support or custom Python versions. See above sections.
# cmake -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=/usr/local "$OPENCV_DIR" \
# 	-D WITH_TBB=ON -D WITH_EIGEN=ON \
# 		-D CMAKE_INSTALL_PREFIX=/usr/local \
# 	-D INSTALL_C_EXAMPLES=ON \
# 	-D INSTALL_PYTHON_EXAMPLES=ON \
# 	-D OPENCV_EXTRA_MODULES_PATH=~/opencv_contrib/modules \
# 	-D BUILD_EXAMPLES=ON ..


cmake -DBUILD_TIFF=ON -DBUILD_opencv_java=OFF -DWITH_CUDA=OFF \
-DENABLE_AVX=ON -DWITH_OPENGL=ON -DWITH_OPENCL=ON -DWITH_IPP=ON \
-DWITH_TBB=ON -DWITH_EIGEN=ON -DWITH_V4L=ON -DWITH_VTK=OFF \
-DBUILD_TESTS=OFF -DBUILD_PERF_TESTS=OFF -DCMAKE_BUILD_TYPE=RELEASE \
-DCMAKE_INSTALL_PREFIX=/usr/local -DOPENCV_EXTRA_MODULES_PATH=${OPENCV_CONTRIB_MODULES_DIR} ..



# At this point, take a look at the console output.
# OpenCV will print a report of modules and features that it can and can't support based on your system and installed libraries.
# The key here is to make sure it's not missing anything you'll need!
# If something's missing, then you'll need to install those dependencies and rerun the cmake command.

# OK, lets actually build this thing!
# Note: You can use the "make -jN" command, which will run N parallel jobs to speed up your build. Set N to whatever your machine can handle (usually <= the number of concurrent threads your CPU can run).
make
# # This will also take a while...

# # Now install the binaries!
sudo make install