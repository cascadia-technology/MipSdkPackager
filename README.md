# MipSdkPackager
This module is made to automate the compiling of NuGet packages based on Milestone's redistributable MIP SDK binaries. The module is configured to point to a repository containing one or more copies of the MIP SDK redistributable binaries. These can be downloaded from [Milestone Systems](https://www.milestonesys.com/community/developer-tools/sdk/) directly.

To publish to NuGet.org or PSGallery, an API key is required. The first time you use this module, you will be asked for your MIP SDK repository path, and your API keys. Unless you're specifically a trusted collaborator for this project, you would need to fork the project and rename the packages for your own purposes, then use your own NuGet/PSGallery API keys. If you're only going to use the build artifacts locally, you can enter anything for your API keys and as long as you don't call Invoke-NuGetPush or Invoke-PublishModule, you can just use the nupkg files directly.

The API keys and repo path are stored in a config.json file @ C:\ProgramData\MipSdkPackager, and the keys are protected both in memory and on disk as a securestring. They are only decrypted for the purpose of calling nuget push or Publish-Module.

## Orientation
There are 8 NuGet packages and 1 PowerShell module in this repo with their manifests and content each in their own subfolders. Also in these folders are update.ps1 scripts which take the MIP SDK version, intended manifest version, and a release note, and then copied the necessary DLL's from the MIP SDK repo before updating the nuspec/psd1 files with the desired version and release notes.

Calling Invoke-Build will update each of these packages, then call the nuget pack command, writing the packages to the Output path, while the CascadiaMipRedist PowerShell module will be copied to Documents\WindowsPowerShell\Modules in preparation for Publish-Module.

## MIP SDK Repo Format
If your repo path is C:\MIPSDKREPO, your directory structure should appear like the following:

```
C:\MIPSDKREPO
\---13.2
    \---Bin
```
It's important for the first level folders of the repo to reflect the MIP SDK version number as you will supply this in your Invoke-Build command. The content of the Bin folder should include numerous DLL files and the Copy*.bat files included with the SDK and redistributable SDK binaries.

## How to Build
Once you've cloned the repo, and created your local MIP SDK repository, you can call reload-module.ps1 to make sure the module is unloaded and imported cleanly.

```
.\reload-module.ps1
```

If it's your first time importing the module, you will need to provide input for the MIP SDK repository path, and API keys.

Next, use Invoke-Build. The following example will build nuget packages using MIP SDK version 13.2, and the version in the packages will be set to 13.2.0, with a release note of "Initial release"

```
Invoke-Build 13.2 13.2.0 "Initial release"
```

You'll find the \*.nupkg files in the Output folder, and the CascadiaMipRedist PowerShell module in it's own folder, both at the root of the repo.
