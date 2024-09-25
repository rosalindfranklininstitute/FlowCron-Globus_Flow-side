# FlowCron-Globus_Flow-side

## Before you start installing the Globus Flow side of FlowCron

To install FlowCron on an HPC, it is strongly advised that you are the PI or a manager of a 
project on the HPC you want to install FlowCron

There are 2 prerequisites for installing FlowCron:
1. The HPC allows the use of `cron` to the PIs and/or managers of projects on the HPC.
2. The HPC has a Globus collection allowing data to be transferred in and out to the project's designated directory location on the HPC.

The first step to install FlowCron is to install the cron service portion of FlowCron in the HPC (in the project's designated directory location on the HPC).

The HPC side portion of FlowCron can be found here (https://github.com/baskerville-hpc/FlowCron-HPC-side)

After you perform this step you can return here, in order to install the Globus Flow that will communicate with the cron service, thus completing the FlowCron installation.

## Installation of the Globus Flow of FlowCron

### Running the bash script

To install the Globus Flow of FlowCron you need access to terminal with `bash` .

This can be realised by using a terminal on either a Linux or macOS machine or by using [Windows Subsystem for Linux](https://learn.microsoft.com/en-us/windows/wsl/install) terminal on a Windows PC/workstation.

First clone this repository and navigate inside it:
```
git clone https://github.com/rosalindfranklininstitute/FlowCron-Globus_Flow-side.git
cd FlowCron-Globus_Flow-side
```
Then execute:
```
bash construct_new_instance_FlowCron_configs.sh
```
Then in the terminal will prompt you to enter some details (read instructions and see the image below):

![image](images/Globus-Flow-Side.png)

1. You'll get asked for a name for this instance of FlowCron, use the same name as you gave to the HPC side, not mandatory but helps tie things together (Question 1).
2. Then, enter the name of the HPC so all Globus Flow messages print it corrently (Question 2).
3. Then, enter the UUID of the HPC's Globus collection (aka the Globus collection used to transfer data in and out to the project's designated directory location on the HPC) (Question 3). \
   To find the UUID of  the HPC's Globus collection:
   1. Click the Collections option in the left-hand menu bar.
   2. Type HPC's Globus collection name (be careful what options are enabled e.g. 'Administered By You`, 'In Use', etc. because this may cause the collection not to appear)
   3. Select the HPC's Globus collection.
   4. The output from this is shown below. The UUID of the HPC's Globus collection name is the last item displayed at the bottom.
![image](images/GlobusUUID.png)
4. Then, in `bash` script will ask for the absolute path to the FlowCron service on the HPC. This is the path to the directory where the HPC Side code was cloned on the HPC system, which should contain the `UploadedFiles` directory, the `CodeToRun` directory, etc. (Question 4). \
   To have this path printed, after you `ssh` to the HPC, navigate to this directory and use the `pwd -P` command. This command will give you the answer free from any symbolic links.
5. Lastly, set the interval of the time to check the job's status (Question 5). \
   This value should be chosen considering the range of running times typical jobs submitted to FlowCron will take. \
   If short jobs are typically submitted, then a short interval can help reduce time cases where the job has finished, but the Flow has yet to recognise this.\
   If longer jobs are typically submitted, then a longer interval can help to keep the size of the Globus Flow logs to a minimal (because if the Flow checks frequently but a job typically takes a lot of time to complete, the Flow logs will be large containing numerous check status statements).

After answering to all `bash` script prompts. A new directory will be created locally with the name given to this instance of FlowCron (Question 1).

In it there will be 2 new `.json` files. One with the `_definition.json` postfix and one with the `_input_schema.json` postfix.

### Create a Globus group to add the users to whom you will share FlowCron's Globus Flow

Before you can use these 2 files in order to publish the FlowCron Globus Flow (aka make it available in the https://app.globus.org)
As the project PI and/or manager you should create a Globus group containing as 'Members' all the project members you would to use FlowCron to automatically submit jobs/units of work.

To do this follow the guide mentioned here
https://docs.globus.org/guides/tutorials/manage-identities/manage-groups/ 

In the rest of this document, we will refer to this group with the name `FlowCron_Globus_group`, but you can name it anything you like. \
As shown in the Overview tab of the group (last figure of the [guide](https://docs.globus.org/guides/tutorials/manage-identities/manage-groups/)), The **Group UUID** is being displayed. \
Please note the **Group UUID** if you are planning to publish the Globus Flow using the Globus CLI (more about this below)

### Deploy FlowCron's Globus Flow using Globus UI

To deploy the FlowCron's Globus Flow via the Globus UI follow step 3 from this guide https://docs.globus.org/guides/tutorials/flow-automation/create-a-flow/#create_the_flow \

In short, you need to first login to https://app.globus.org \
On the left-hand side menu, select Flows and then click on the **Deploy a Flow** tab as shown in the image below:
![image](images/Globus_step_1.png)

Then click on the **Deploy Flow** button, as shown in the image below:
![image](images/Globus_step_2.png)

In the new window (see image below), give the Flow Name. \
The name should be such that can it is clear to which HPC and which project in the HPC the FlowCron will send the submitted jobs/units of work. \
Upload the 2 `.json` files appropriately. \
You should upload the `FlowCron-<FLOWCRON_INSTANCE_NAME>_definition.json` in the Flow Defination field. \
And the `FlowCron-<FLOWCRON_INSTANCE_NAME>_input_schema.json` in the Input Schema field. \
Fill the other text filed if you wish. \
Lastly, click **Deploy Flow** to deploy it.
![image](images/GlobusFlows-FilledIn.png)

Finally, you should publish the new Flow to the `FlowCron_Globus_group` (the one created in the [previos step](#create-a-globus-group-to-add-the-users-to-whom-you-will-share-flowcrons-globus-flow))

You can add this group to the flow, by going to Flows on the left-hand menu bar, and click on the **Library** tab.

To find the Globus Flow you just created easier, you can select the **Administered by me** checkbox to reduce the number of displayed flows.

When you've found your Flow, click on the name of the flow, the click the **Roles** tab and finally the **Assign New Role** button.

This will open a new window as shown in the image below.

In this new window, select the **Group** option in the **Assign To** field. \
Then press the **Select a Group** button, and find and select the `FlowCron_Globus_group` group (or how else you have named your group in the [previos step](#create-a-globus-group-to-add-the-users-to-whom-you-will-share-flowcrons-globus-flow)). \
Finally, select the **Runnable By** option in the **Role** field, so all members of the group can run FlowCron's Globus Flow. \
Click the **Add Role** button to add the group with this role.

![image](images/GlobusFlow-AssignNewRole.png)

You may repeat the **Assign New Role** process mentioned above, if you want to allow to multiple groups run the flow, or if you want to add specific
users/groups as administrators of the flow.

### Deploy FlowCron's Globus Flow using Globus CLI

An alternative way to deploy FlowCron's Globus Flow is via Globus CLI.

The advantage of using Globus CLI is that you can deploy the flow and add roles to the flow all in one step.

The disadvantage is that you need to be bit familiarized with concepts like pip, python, (and maybe conda), and how Linux/macOS terminals work.

Here is the installation instructions for it https://docs.globus.org/cli/ .

To run Globus CLI you need a terminal with python-pip added in the PATH. \
The easiest way we suggest for installing python is using the miniforge conda installer (https://github.com/conda-forge/miniforge) \
After the installation you may create multiple conda environments (read more [here](https://conda.io/projects/conda/en/latest/user-guide/tasks/manage-environments.html)) 
and may create one with python-pip specifically to install and run the Globus CLI python package. \
If you install python-pip using miniforge and a new conda environment, please use the `pip` option and not the `pipx` option, from the Globus CLI installation instructions.

After you finish installing the Globus CLI, first run the `globus login` command (read more [here](https://docs.globus.org/cli/reference/login/))

After you login, you can deploy FlowCron's Globus Flow, with the `globus flow create` command (read more [here](https://docs.globus.org/cli/reference/flows_create/))

Namely, below is an example command on how to deploy FlowCron's Globus Flow and add the `FlowCron_Globus_group` group as a group that can run the flow in one go (replace <> appropriately).
```
globus flows create --input-schema FlowCron-<FLOWCRON_INSTANCE_NAME>_input_schema.json --starter urn:globus:groups:id:<FlowCron_Globus_group_UUID> '<FLOWCRON_INSTANCE_NAME>' FlowCron-<FLOWCRON_INSTANCE_NAME>_definition.json 
```

### How to use FlowCron's Globus Flow as a user

#### Prepare a Job / Unit of Work

In FlowCron you select-submit a whole Job directory (called Unit of Work).
The Unit of Work should have the following directory/file structure:

```
Job_Dir
   ├── data
   │    └── <data-files-or-directories>
   └── scripts
        └── submission_script.sh
```
* There should always be 2 directories named `data` and `scripts` (even if they are empty directories).
* There can be other sub-directories apart from the `data` and `scripts` ones.
* There should **not** be any sub-directory named `sentinels`.
* Within the `scripts` sub-directory, there should be a slurm script named `submission_script.sh` this is the script that will be run.

The idea behind FlowCron is that there will be one per project in a HPC. \
Therefore, the `submission_script.sh` slurm script, should be written similar to how a project slurm scripts are being written. \
This generally means that slurm arguments like `--qos`, `--account` or `--partition` should have the appropriate values depending on the project. \
Other slurm arguments should also be filled depending on project and/or the job about to be computed. 

Below is the template `submission_script.sh` that should be used (replace <> appropriately):

```bash
#!/bin/bash
#SBATCH --qos=<qos>
#SBATCH --account=<account>
#SBATCH --time=d-hh:mm:ss
#SBATCH --ntasks=<ntasks>
#SBATCH --cpus-per-task=<cpus-per-task>
#SBATCH --gpus-per-task=<gpus-per-task>

# Module load section
module purge
module load <module-1>
...
module load <module-n>

# NO EDIT ZONE: START
working_directory=$1
echo "${SLURM_JOB_ID}: Working directory is ${working_directory}"

if ! [ -d $working_directory ]; then
  echo "${SLURM_JOB_ID}: ${working_directory} has not been found"
  exit 1
fi

set -e

cd "${working_directory}"
# NO EDIT ZONE: END

# List of commands for the job
```

In the beginning of the `submission_script.sh` slurm script, sbatch options are being added (e.g. `--qos`, `--time`, etc.) \
Please fill them appropriately.

Please avoid using the `--output` or `-o` and the `--error` or `-e` options because they are being used by FlowCron and overwritten anyway.

Then it is the `Module load section`. \
Please add here any `module` commands so all necessary dependencies for the job are loaded.

Then demarcated with the `# NO EDIT ZONE: START` and `# NO EDIT ZONE: END` comments, there is a section with commands you should include in the script as is, in this position, and not edit them. \
These commands are there to help with logging details in the slurm `.out` file in case there are issues with the job submitted, which need to be debugged.

Finally, after the `NO EDIT ZONE` all job commands can be added. (`List of commands for the job` section)

**Do not use any `$HOME` and/or `$USER` variables.** \
This is because the script will be submitted using the account of the person that has setup FlowCron (typically the project PI and/or a project manager)

The slurm script is being submitted with a `sbatch` command and with the present working directory being the `Job_Dir` (aka `sbatch scripts/submission_script`). \
Since the present working directory is the `Job_Dir` directory if you want for instance to point to a file e.g. `test.txt` in a directory named `test` which is the `data` directory, point to using the path relative path `data/test/test.txt`

The general rule about path is that:
* If the files/folders (data, models, etc) are packaged with the job directory (e.g. maybe within the `data` directory) reference to them using relative paths
* If the inputs (data, models, etc) are already somewhere in the HPC (e.g. in your personal directory) use absolute paths
* For paths of output-resulting files/folders use relative paths


#### Submit a Job / Unit of Work to FlowCron's Globus Flow

**Important: If you haven't submitted via FlowCron for some time, or if it is your first time, please do the following:** \
Login to Globus (https://app.globus.org) and in the left-hand menu bar, then select **File Manager**, and then in access HPC's Globus collection. \
Some HPCs use OIDC Globus Collections that require re-authentication every X number of days. By preemptively accessing the HPC's Globus collection, it allows FlowCron's Globus Flow to also access it without the need to authenticate. 

After you create a job directory, to submit it, login to Globus (https://app.globus.org) and in the left-hand menu bar, then select **Flows**, and then go to the **Library** tab. \
To find the Globus Flow you just created easier, you can select the **Administered by me** checkbox to reduce the number of displayed flows. \
Select the appropriate FlowCron flow (in the image below is the example of one simply named `FlowCron`) \
Click **Start**.

![image](images/StartingFlow.png)

**Important:** When you FlowCron's Globus Flow for the first time you have tick Allow in the Globus prompt, in order to start using it (see image below).
![image](images/GlobusAuthorise.png)

The first thing that will be displayed is the **Guided** tab (see image below). \
In this view, select the Globus collection from which you can upload the Unit of Work you want to submit. You can either use the UUID of this collection, or start typing its name. \
Then type the path to the Unit of Work directory (in our example the path to the `Job_Dir` directory). \
This path has to end with a `/` character to signify you upload a whole directory (in our Unit of Work example above, it is the `Job_Dir` directory). \
You can select if you want to clean up after processing. By default, this option is off. \
Label this run of the flow and click **Start run**.

![image](images/GlobusFlow-FilledIn.png)

**Important:** If you have not used FlowCron's Globus Flow for some time or if it is your first time, please do the following after you click **Start run**. \
Click in the left-hand menu bar the **Flows** option and then the **Runs** tab and open the flow run you just submitted. \
Wait a bit to ensure that you provide additional authorization or consents in case they are requested. \
Typically, when FlowCron's Globus Flow is used for the first time it requires authorization/consent in order to be allowed to access both your source Globus collection and the HPC's Globus collection. Otherwise, it will not continue further. \
Thankfully, an email will be sent (to the email address associated your Globus account) in case additional authorization or consents is needed (see image below).

![image](images/GlobusReview-Consents.png)

Regardless though, after you submitted a run, it is good practice to click in the left-hand menu bar the **Flows** option and then the **Runs** tab, you can see your Flow running. \
If you click on it and go the **Event Log** tab you can see at which state it is (see image below).

![image](images/GlobusFlows-Log-Inprogress.png)

**Only for expert users who know what they are doing**, you may also every time you submit a new run, to open the **Roles** tab of the Flow run and click the **Assign New Role** and add as **Manager** the person who deployed FlowCron's Globus Flow (it is typically the HPC project PI and/or a manager of the HPC project) **and only this person**. \
**Do not assign a role to anyone else nor attempt to assign any role if you are not experienced with using the Globus UI** \
We have already communicated with the Globus support team for a future feature to be added. This feature will allow Flow administrators to set to be the only Manager in all the runs of their Flows and to be able to disable the ability of people who can run their Flows from being capable of assign or change the roles on Flows runs.

After the Unit of Work finishes being computed on the HPC (either successfully or unsuccessfully), any file/folder generated within the Unit of Work directory (in our example the `Job_Dir`) will be transferred back (transfer with sync to not waste time re-transferring the original files back) in the same location (Globus collection/path) from where you uploaded the Unit of Work.

If the `Delete job directory in <HPC-name> after transferring the results back?` was set to `false` , then

If the Unit of Work finished successfully, then its directory will continue being stored in the cron service directory location (the path provided in Question 4 in [here](#running-the-bash-script)), then under the `AnalysedFiles` directory, and the Unit of Work directory will be titled `<Unit_of_Work_directory_name>_<flow_run_UUID>`

If the Unit of Work finished unsuccessfully, then its directory will continue being stored in the cron service directory location (the path provided in Question 4 in [here](#running-the-bash-script)), then under the `FailedJobs` directory, and the Unit of Work directory will be titled `<Unit_of_Work_directory_name>_<flow_run_UUID>`

For more info you can also check the Flow runs logs in the **Event Log** tab.