#!/usr/bin/env bash
# reference http://docs.ros.org/indigo/api/moveit_tutorials/html/doc/ikfast_tutorial.html
gIf_Round_Collada_Numbers=false
gIf_Generate_DAE=false
gURDFFileFull=""
gURDFFilePath=""
gURDFFileName=""
gURDFFileExt=""

gDAEFileName=""
gDAEFileNameExt=""
gDAEFileNameRoundExt=""

gProjName=""
gRobotName=""


gWorkingDir="/tmp/urdf2dae"
gOrigDir=`pwd`

function ymake
{
	catkin_make -j3 install -DCMAKE_INSTALL_PREFIX:PATH= -C ${RD_ROS_WORKSPACE} -DCMAKE_BUILD_TYPE=Debug 
}
function yhome
{
	cd ${RD_ROS_WORKSPACE}/src/
}

# to display .dae robot in openrave
# openrave *.dae

# generate IKFast cpp from DAE file
# example:
#   generateIKFastFromDAE ${gDAEFileNameExt} ${baselink} ${eelink} \
#       ${freeindexParam} ${IKcppName}
function generateIKFastFromDAE()
{
    local lDAEFileNameExt=$1
    local lbaselink=$2
    local leelink=$3
    local lFreeindexParam=$4
    local lIKcpp_Name=$5
    python `openrave-config --python-dir`/openravepy/_openravepy_/ikfast.py \
		--robot=${lDAEFileNameExt} --iktype=transform6d --baselink=${lbaselink} \
		--eelink=${leelink} ${lFreeindexParam} --savefile=${lIKcpp_Name}
}

# usage:
# createIKFastPluginROSPackage ${gProjName}
#   ${RobotName} ${planningGroupName} ${rosIKPackageName} ${ikfast_cpp_file}

function createIKFastPluginROSPackage()
{
    local RobotName=$1
    local planningGroupName=$2
    local rosIKPackageName=$3
    local ikfast_cpp_file=$4
    rosrun moveit_ikfast create_ikfast_moveit_plugin.py \
		${RobotName} ${planningGroupName} ${rosIKPackageName} ${ikfast_cpp_file}

}
function usage()
{
    if [ "$1." != "." ]; then
	echo ""
	echo "Error:  $1"
    fi
    cat <<EOF
usage:$0 OPTION

OPTIONS:
 -u <robot.urdf>	input the urdf file
 -g 				generate DAE and IK.cpp

EOF
    exit -1
}


if [ $# -eq 0 ]; then
    usage
fi
while getopts ":u:r" FLAG; do
    case "${FLAG}" in
	u) 
	    gURDFFileName=${OPTARG}
	    if [[ -a $gURDFFileName ]]; then
	    	gURDFFileFull=`readlink -f $gURDFFileName`
	    	echo "converting file, $gURDFFileFull"
	    	gURDFFileName=$(basename "$gURDFFileFull")
	    	echo "gURDFFileName: 	$gURDFFileName"
			gURDFFileExt="${gURDFFileName##*.}"
	    	echo "gURDFFileExt: 	$gURDFFileExt"

			gURDFFileName="${gURDFFileName%.*}"
	    	echo "gURDFFileName: 	$gURDFFileName"

			gURDFFilePath=$(dirname "${gURDFFileFull}")
	    	echo "gURDFFilePath: 	$gURDFFilePath"

			gDAEFileName=${gURDFFileName}
			gDAEFileNameExt="${gDAEFileName}.dae"
			gDAEFileNameRoundExt="${gDAEFileName}.round.dae"

			gProjName=${gURDFFileName}
			gRobotName=${gProjName}
		else
			echo "urdf file, $gURDFFileName doesn't exist"
			usage
		fi
	    ;;
	r) 
	    gIf_Round_Collada_Numbers=true
	    ;;
    g) 
	    gIf_Generate_DAE=true
	    ;;
	\?) 
	    usage
	    ;;
	*)
	    usage
	    ;;
    esac
done

# main
if [[ -z $gURDFFileFull ]]; then
    usage
fi

# rm -rf $gWorkingDir
mkdir -p $gWorkingDir

pushd $gWorkingDir
	source ~/.bashrc

	checkRet=`check_urdf ${gURDFFileFull} | grep "Success"`
	
	if [[ -z $checkRet ]]; then
		echo "check_urdf failed. URDF file invalid"
	else
		echo "check_urdf Successed."
	fi

	checkRet=`rosrun collada_urdf urdf_to_collada ${gURDFFileFull} ${gDAEFileNameExt}`
	
	echo -e "\ncollada_urdf result: $checkRet \n"

	rosrun moveit_ikfast round_collada_numbers.py ${gDAEFileNameExt} ${gDAEFileNameRoundExt} 5 > /dev/null

	echo -e "RobotLink in .dae\n"
	openrave-robot.py ${gDAEFileNameExt} --info links
	
	baselink=""
	eelink=""
	freeindex=""
	freeindexParam=""
	while [[ true ]]; do
		echo -n "Enter base link number and press [ENTER]: "
		read baselink
		[[ $baselink =~ ^-?[0-9]+$ ]] && break;
	done
	
	while [[ true ]]; do
		echo -n "Enter end effector link number and press [ENTER]: "
		read eelink
		[[ $eelink =~ ^-?[0-9]+$ ]] && break;
	done
	
	while [[ true ]]; do
		echo -n "Add freeindex link number, or 'n' for none, press [ENTER]: "
		read freeindex
		if [[ $freeindex =~ ^-?[0-9]+$ ]]; then
			freeindexParam="${freeindexParam} --freeindex=${freeindex}"
		fi
		[[ $freeindex = 'n' ]] && break;
	done
	
	# openrave.py  --database inversekinematics \
		# --robot=${gDAEFileNameExt} --iktype=transform6d --baselink=${baselink} \
		# --eelink=${eelink} ${freeindexParam} --savefile="${gURDFFilePath}/${gURDFFileName}_ik.cpp"

	IKcppName=${gProjName}_ik.cpp
	IKRoundcppName=${gProjName}_round_ik.cpp
	if [[ gIf_Generate_DAE -eq "true" ]]; then
		generateIKFastFromDAE ${gDAEFileNameExt} ${baselink} ${eelink} \
       ${freeindexParam} ${IKcppName}
	fi
   
   # generateIKFastFromDAE ${gDAEFileNameRoundExt} ${baselink} ${eelink} \
#        ${freeindexParam} ${IKRoundcppName}
	echo -e "\nstart to create IK package\n"
	yhome
	echo "change work dir to $PWD"

	ikfast_cpp_file=${gWorkingDir}/${IKcppName}
	ikfast_round_cpp_file=${gWorkingDir}/${IKRoundcppName}

	planningGroup=""
	echo -n "Enter planningGroup in moveit SRDF and press [ENTER]: "
	read planningGroup

    rosIKPackageName=${gProjName}_ikfast_plugin
	rosIKRoundPackageName=${gProjName}_ikfast_round_plugin
	catkin_create_pkg ${rosIKPackageName}
	catkin_create_pkg ${rosIKRoundPackageName}
	ymake | grep ikfast

	createIKFastPluginROSPackage ${gRobotName} \
	    ${planningGroup} ${rosIKPackageName} ${ikfast_cpp_file}

    createIKFastPluginROSPackage ${gRobotName} \
	    ${planningGroup} ${rosIKRoundPackageName} ${ikfast_round_cpp_file}
	ymake | grep ikfast

popd


# trouble shooting 
# problem 1, when generating ikfast.cpp, this error may occur
# TypeError("symbolic boolean expression has no truth value.")
# solution:  https://github.com/rdiankov/openrave/issues/387
# sudo pip uninstall sympy
# sudo pip install sympy==0.7.1
