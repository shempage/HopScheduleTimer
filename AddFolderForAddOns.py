import os, sys, filecmp, shutil, glob, zipfile, fileinput, subprocess

workspace = os.environ['WORKSPACE']
sys.path.append(workspace)

print(workspace)


from mod_pbxproj import XcodeProject

buildFolder = os.path.join(workspace, "CurrentBuild")
projectToBuild = "HopScheduleTimer"
addonsFolder = os.path.join(workspace, 'Addons')


projectPath = os.path.join(buildFolder, projectToBuild + ".xcodeproj", "project.pbxproj")
project = XcodeProject.Load(projectPath)
project_group = project.get_or_create_group(projectToBuild)
print("  Shem Adding all addons to the Xcode project...")
project.add_folder(addonsFolder, project_group)

if project.modified:
    project.backup()
    project.save()