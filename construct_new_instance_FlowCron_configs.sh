#!/bin/bash

FLOWCRON_INSTANCE_NAME=""
HPC_NAME=""
SOURCE_ENDPOINT_UUID=""
FLOWCRON_BASE_PATH=""
TIME_OPTS=("1" "2" "5" "10" "15" "30")

#Get the name of the HPC
while true ; do
  read -p "What is the name of this particular FlowCron instance (This is to generate the updated json files as 'FlowCron-<instance_name>_definition.json' and 'FlowCron-<instance_name>_input_schema.json'? " FLOWCRON_INSTANCE_NAME
  if [ ! -z $FLOWCRON_INSTANCE_NAME ]; then
	  break
  else
	  echo "Please enter a value for the name of this FlowCron instance."
	fi
done

#Get the name of the HPC
while true ; do
  read -p "What is the name of the HPC? " HPC_NAME
  if [ ! -z $HPC_NAME ]; then
	  break
  else
	  echo "Please enter the name of the HPC (this is to be used in labels to properly address it)."
	fi
done

#Get a name for the script from the user.
while true ; do
  read -p "What is the UUID of the HPC's Globus Collection? " SOURCE_ENDPOINT_UUID
  if [[ $SOURCE_ENDPOINT_UUID =~ ^\{?[A-F0-9a-f]{8}-[A-F0-9a-f]{4}-[A-F0-9a-f]{4}-[A-F0-9a-f]{4}-[A-F0-9a-f]{12}\}?$ ]]; then
	  break
  else
	  echo "Please enter valid UUID."
	fi
done

#Get the absolute path to the FlowCron service on the HPC
while true ; do
  read -p "What is absolute path to the FlowCron service on the HPC (aka what is the absolute path to the directory that has the 'UploadedFiles', 'CodeToRun', etc. as subdirectories)? " FLOWCRON_BASE_PATH
  if [[ $FLOWCRON_BASE_PATH == /* ]] && [[ $FLOWCRON_BASE_PATH != */ ]] ; then
	  break
  else
	  echo "Please enter the absolute to the FlowCron service directory (please do not add '/' as the last character)"
	fi
done

#Ask how many minutes should this repeat
echo -e "\nEvery how many minutes should the Globus Flow aspect of FlowCron check for the job's status on the HPC? "
select time in "${TIME_OPTS[@]}"
do
    for i in "${TIME_OPTS[@]}"; do
	if [ "${time}" == "${i}" ]; then
            FLOW_WAIT_MIN=$((time*60)); break 2;
	fi
    done
done

mkdir "$FLOWCRON_INSTANCE_NAME"

cp FlowCron-template_definition.json "$FLOWCRON_INSTANCE_NAME"/FlowCron-"$FLOWCRON_INSTANCE_NAME"_definition.json
cp FlowCron-template_input_schema.json "$FLOWCRON_INSTANCE_NAME"/FlowCron-"$FLOWCRON_INSTANCE_NAME"_input_schema.json

sed -i "s|HPCNAME|$HPC_NAME|g" "$FLOWCRON_INSTANCE_NAME"/FlowCron-"$FLOWCRON_INSTANCE_NAME"_definition.json
sed -i "s|HPCNAME|$HPC_NAME|g" "$FLOWCRON_INSTANCE_NAME"/FlowCron-"$FLOWCRON_INSTANCE_NAME"_input_schema.json
sed -i "s|SOURCE_ENDPOINT_UUID|$SOURCE_ENDPOINT_UUID|g" "$FLOWCRON_INSTANCE_NAME"/FlowCron-"$FLOWCRON_INSTANCE_NAME"_definition.json
sed -i "s|FLOWCRON_BASE_PATH|$FLOWCRON_BASE_PATH|g" "$FLOWCRON_INSTANCE_NAME"/FlowCron-"$FLOWCRON_INSTANCE_NAME"_definition.json
sed -i "s|FLOW_WAIT_MIN|$FLOW_WAIT_MIN|g" "$FLOWCRON_INSTANCE_NAME"/FlowCron-"$FLOWCRON_INSTANCE_NAME"_definition.json
