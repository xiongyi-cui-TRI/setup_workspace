gIf_Round_Collada_Numbers=false
gURDFFileFull=""
gURDFFilePath=""
gURDFFileName=""
gURDFFileExt=""

gDAEFileName=""
gDAEFileNameExt=""
gDAEFileNameRoundExt=""

gWorkingDir="/tmp/urdf2dae"
gOrigDir=`pwd`



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

			# gURDFFilePath=$(dirname "${gURDFFileName}")
	  #   	echo "gURDFFilePath: 	$gURDFFilePath"

			gDAEFileName=$gURDFFileName
			gDAEFileNameExt="${gDAEFileName}.dae"
			gDAEFileNameRoundExt="${gDAEFileName}.round.dae"
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


rm -rf $gWorkingDir
mkdir -p $gWorkingDir

pushd $gWorkingDir
	checkRet=`check_urdf ${gURDFFileFull} | grep "Success"`
	
	if [[ -z $checkRet ]]; then
		echo "check_urdf failed. URDF file invalid"
	fi

	checkRet=`rosrun collada_urdf urdf_to_collada ${gURDFFileFull} ${gDAEFileNameExt}`
	
	echo "collada_urdf result: $checkRet"

	rosrun moveit_ikfast round_collada_numbers.py ${gDAEFileNameExt} ${gDAEFileNameRoundExt} 5 > /dev/null

	
popd
