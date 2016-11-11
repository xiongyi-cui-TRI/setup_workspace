gIf_Round_Collada_Numbers=false
gURDFFileFull=""
gURDFFilePath=""
gURDFFileName=""
gURDFFileExt=""

gDAEFileName=""
gDAEFileNameExt=""
gDAEFileNameRoundExt=""

gProjName=""


gWorkingDir="/tmp/urdf2dae"
gOrigDir=`pwd`


# to display .dae robot in openrave
# openrave *.dae

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

			gDAEFileName=$gURDFFileName
			gDAEFileNameExt="${gDAEFileName}.dae"
			gDAEFileNameRoundExt="${gDAEFileName}.round.dae"

			gProjName=$gURDFFileName
		else
			echo "urdf file, $gURDFFileName doesn't exist"
			usage
		fi
	    ;;
	r) 
	    gIf_Round_Collada_Numbers=true
	    ;;
	\?) 
	    usage
	    ;;
	*)
	    usage
	    ;;
    esac
done


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
	python `openrave-config --python-dir`/openravepy/_openravepy_/ikfast.py \
		--robot=${gDAEFileNameExt} --iktype=transform6d --baselink=${baselink} \
		--eelink=${eelink} ${freeindexParam} --savefile=${IKcppName}
	
	echo -e "\nstart to create IK package\n"
	`yhome`

	planningGroup=""
	rosIKPackageName=${gProjName}_ikfast_plugin
	ikfast_cpp_file=${gWorkingDir}/${IKcppName}
	moveitConfigPackageName=""

	echo -n "Enter planningGroup in moveit SRDF and press [ENTER]: "
	read planningGroup

	echo -n "Enter moveitConfigPackageName, remove the  and press [ENTER]: "
	read planningGroup

	catkin_create_pkg ${rosIKPackageName}
	rosrun moveit_ikfast create_ikfast_moveit_plugin.py \
		${gProjName} ${gProjName} ${rosIKPackageName} ${ikfast_cpp_file}


popd


# trouble shooting 
# problem 1, when generating ikfast.cpp, this error may occur
# TypeError("symbolic boolean expression has no truth value.")
# solution:  https://github.com/rdiankov/openrave/issues/387
# sudo pip uninstall sympy
# sudo pip install sympy==0.7.1
