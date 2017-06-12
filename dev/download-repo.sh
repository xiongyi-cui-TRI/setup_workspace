(
cd $RD_LIB_PATH
git clone git@github.com:RedDragon-Tech/RD_FreeCAD.git
cd RD_FreeCAD
mkdir build
./setup/freecad_def.sh
)

(
	cd ~/workspace/src
	git clone git@github.com:RedDragon-Tech/RD_RobotPlanning.git
	git clone git@github.com:RedDragon-Tech/robotmodel_moveit.git

	# 
	git clone https://github.com/davetcoleman/graph_msgs.git
	git clone https://github.com/cuixiongyi/rviz_visual_tools.git
	(cd rviz_visual_tools; git checkout cxy_off_indigo-devel; )
	git clone https://github.com/cuixiongyi/moveit_visual_tools.git
	(cd moveit_visual_tools; git checkout cxy_off_indigo-devel; )

)