
echo "
RD_library build info"
cat ~/workspace/install/include/RD_Common/RD_Build_Info.build.h| grep "defin"| cut -d " " -f2-

echo "

RD_FreeCAD build info"
cat ~/library/RD_FreeCAD/RD_CAD_Build_Info.build.h | grep "defin"| cut -d " " -f2-
echo "
"