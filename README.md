# deploy_agent_Lucky-Umoka

## What This Script Does
`setup_project.sh` automates the creation of a Student Attendance Tracker workspace.

## How to Run
1. Place source files in the `SourceFiles/` directory
2. Run: `bash setup_project.sh`
3. Enter a project name when prompted (e.g. `v1`)
4. Choose whether to update attendance thresholds

## How to Trigger the Archive Feature
Press `Ctrl+C` at any point while the script is running.
The script will:
1. Bundle the incomplete directory into a `.tar.gz` archive
2. Delete the incomplete directory
3. Exit cleanly

## Directory Structure Created
attendance_tracker_{input}/

├── attendance_checker.py

├── Helpers/

│   ├── assets.csv

│   └── config.json

└── reports/

└── reports.log
