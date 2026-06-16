 #!usr/bin/env bash

 read -p "Enter project name (e.g V1, ALU): " input

 DIR_NAME="attendance_tracker_${input}"

 userCancel() {
	 echo ""
	 echo "Interrupt detected!"
	 echo "Implementing signal trap..."
	 echo "Cleaning up..."

	 if [ -d "DIR_NAME"] then
		 tar -czf "${DIR_NAME}_archive.tar.gz" "DIR_NAME"
		 echo " Archive created: ${DIR_NAME}_archive.tar.gz"
		 rm -rf "DIR_NAME"
		 echo"Incomplete directory deleted."

	fi

	echo "Exiting."
	exit 1
}

trap userCancel SIGINT SIGTERM

echo "Creating project directory: $DIR_NAME"

mkdir -p "$DIR_NAME/Helpers"
mkdir -p "$DIR_NAME/reports"

if [$? -ne 0]; then
	echo "ERROR! Could not create directories. Check permissions"
	exit 1
fi

echo "Directories created successfully!"

if [! -f "SourceFiles/attendance_checker.py"]; then
	echo "ERROR! SourceFiles/attendance_checker.py not found"
	exit 1

fi

cp SourceFiles/attendance_checker.py "$DIR_NAME/attendance_checker.py"
cp SourceFiles/assets.csv "$DIR_NAME/Helpers/assets.csv"
cp SourceFiles/config.json "$DIR_NAME/Helpers/config.json"
cp SourceFiles/reports.log "$DIR_NAME/reports/reports.log"

echo "Files copied successfully!"

echo ""
echo "Current thresholds - Warning: 75%, Failure: 50%"
read -p "Do you want to update the thresholds (yes/no): " update_request

update_request=$(echo "$update_request" | tr '[:upper:]' '[:lower:}')

if [ "$update_request" ="yes" ]; then
	read -p "Enter a new number for the warning threshold (default is 75): " warningtVal

	if ! [["$warningtVal" =~ ^[0-9]+$]]; then
		echo "Invalid input. Using default warning threshold value 75!"
		warningtVal =75
	fi

	read -p "Enter a new number for the failure threshold (default is 50): " failuretVal

	if ! [["$failuretVal" =~ ^[0-9]+$]]; then
		echo "Invalid input. Using default failure threshold value 50!"
		failuretVal =50
	fi

	sed i "s/\"warning\": [0-9]*/\"warning\": $warningtVal/" "$DIR_NAME/Helpers/config.json"
	sed i "s/\"failure\": [0-9]*/\"failure\": $failuretVal/" "$DIR_NAME/Helpers/config.json"

	echo "config.json has been updated with Warning: $warningtVal%, Failure: $failuretVal%"
else
	echo "Keeping default thresholds"

fi

echo ""
echo "Running environment health check..."

if command -v python3 > /dev/null 2>&1; then
	PYTHON_VERSION=$(python3 --version)
	echo "Python3 is installed: $PYTHON_VERSION"
else
	echo "WARNING: Python3 is not installed. The attendance checker will not run!"
fi

echo ""
echo "Verifying directory structure..."

if [ -d "$DIR_NAME" ] && \
   [ -d "$DIR_NAME/Helpers" ] && \
   [ -d "$DIR_NAME/reports" ] && \
   [ -f "$DIR_NAME/Helpers/assets.csv" ] && \
   [ -f "$DIR_NAME/Helpers/config.json" ] && \
   [ -f "$DIR_NAME/reports/reports.log" ]; then
   echo "Directory structure verified successfully!"
else 
   echo "ERROR: Directory structure is incomplete."
   exit 1
fi


echo ""
echo "Project setup complete!"
echo "Directory: $DIR_NAME"
echo "To run the tracker: cd $DIR_NAME && python3 attendance_checkers.py"
echo "To trigger archive: Press Ctrl+C while the script is running"
echo ""

