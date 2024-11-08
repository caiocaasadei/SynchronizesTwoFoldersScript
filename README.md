# SynchronizesTwoFoldersScript
Script that synchronizes two folders: source and replica. The script should maintain a full, identical copy of source folder  at replica folder.

1. Synchronization must be one-way: after the synchronization content of the replica folder should be modified to exactly match content of the source folder;

2. File creation/copying/removal operations should be logged to a file and to the console output;

3. Folder paths and log file path should be provided using the command line arguments;

4. Do not use robocopy and similar utilities.


# How to use

Download or Create the Script:
If you haven't already, copy the PowerShell script into a .ps1 file (e.g., SyncFolders.ps1).
Make sure the script is saved in a directory you can easily access.

Prepare the Directories:

Ensure you have the following folders:

- Source Folder: The folder whose content will be replicated.

- Replica Folder: The folder that will be synchronized to match the source.

- Log File: The file where log entries will be written.

- Run the Script: Open PowerShell and navigate to the directory where the SyncFolders.ps1 script is located.

Use the following syntax to run the script:

 -.\SyncFolders.ps1 -sourcePath "C:\Path\To\Source" -replicaPath "C:\Path\To\Replica" -syncInterval 600 -logFilePath "C:\Path\To\LogFile.txt"

Replace the following placeholders with actual values:

C:\Path\To\Source: The full path to your source folder.

C:\Path\To\Replica: The full path to your replica folder.

600: The synchronization interval in seconds (e.g., 600 = 10 minutes).

C:\Path\To\LogFile.txt: The path to your log file.
