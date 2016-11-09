# reference http://stackoverflow.com/questions/13316437/insert-lines-in-a-file-starting-from-a-specific-line


##  example
## :~$ cat text.txt 
## foo
## bar
## baz
## ~$ insertAfter text.txt 'bar' 'this is the new line'
## ~$ cat text.txt 
## foo
## bar
## this is the new line
## baz

function insertAfterLine # file line newText
{
   local file="$1" line="$2" newText="$3"
   sudo sed -i -e "/^$line$/a"$'\\\n'"$newText"$'\n' "$file"
}
function insertBeforeLine # file line newText
{
   local file="$1" line="$2" newText="$3"
   sudo sed -i -e "/^$line$/i"$'\\\n'"$newText"$'\n' "$file"
}

# insert a ros python path fix
insertBeforeLine /opt/ros/indigo/bin/catkin_find 'from catkin.find_in_workspaces import find_in_workspaces'\
 "sys.path.append('/opt/ros/indigo/lib/python2.7/dist-packages')"
# pwd
# sudo sed -i  "/from catkin.find_in_workspaces import find_in_workspaces/asys.path.append('/opt/ros/indigo/lib/python2.7/dist-packages')\n" "/opt/ros/indigo/bin/catkin_find"
