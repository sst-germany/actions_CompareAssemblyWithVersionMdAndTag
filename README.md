# actions_CompareAssemblyWithVersionMdAndTag

This action reads the version number from the provided AssemblyPath and 
compares it with the version number in the VERSION.md file and the Git tag.
The Git tag must adhere to the schema 'releases/v{assembly-version}'.

The action is executed on a windows powershell.