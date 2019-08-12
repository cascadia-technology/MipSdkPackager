# MipSdkPackager
This module is made to automate the compiling of NuGet packages based on Milestone's redistributable MIP SDK binaries. The module is configured to point to a repository containing one or more copies of the MIP SDK redistributable binaries. These can be downloaded from [Milestone Systems](https://www.milestonesys.com/community/developer-tools/sdk/) directly.

To publish to NuGet.org or PSGallery, an API key is required. The first time you use this module, you will be asked for your MIP SDK repository path, and your API keys. Unless you're specifically a trusted collaborator for this project, you would need to fork the project and rename the packages for your own purposes, then use your own NuGet/PSGallery API keys. If you're only going to use the build artifacts locally, you can enter anything for your API keys and as long as you don't call Invoke-NuGetPush or Invoke-PublishModule, you can just use the nupkg files directly.

The API keys and repo path are stored in a config.json file @ C:\ProgramData\MipSdkPackager, and the keys are protected both in memory and on disk as a securestring. They are only decrypted for the purpose of calling nuget push or Publish-Module.

## MIP SDK Repo Format
If your repo path is C:\MIPSDKREPO, your directory structure should appear like the following:

```
C:\MIPSDKREPO
\---13.2
    \---Bin
```
The content of the Bin folder should include numerous DLL files and the Copy*.bat files included with the SDK and redistributable SDK binaries.
