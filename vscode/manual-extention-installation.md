# Install extention manually
Sometimes, vscode is not able to automatically install the extention manually. To resolve this issue, we can simply download the extention file (with a .vsix exntention name)  and use the command "Extentions: Install from VSIX" from the command pallate.

# Incase that manuall intallation fails
1. It seems that the current vscode has a bug. If you disables the manually installed extention (like the GitLens), you would not be able to restart it or install it in any way. 
2. To resolve this issue, go to ```~/.vscode-server/``` folder, delete the extention under the ```~/.vscode-server/extentions/``` folder. 
3. Then remove the correponding json entry under the ```~/.vscode-server/extentions/extentions.json``` file.