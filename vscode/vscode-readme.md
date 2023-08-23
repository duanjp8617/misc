# Preferred Theme:

I think the following themes are good candidates:

1. `Quiet Light` seems to be pretty good.
2. `Dark (Visual Studio)`
3. The `Dracula` theme from the `Dracula` extention

# Useful extentions:

## Extentions that are installed globaly:

1. Awesome Emacs Keymap
2. Dracula Official
3. Remote - SSH
4. WSL

## Extentions that are installed remotely:

1. clangd
2. pylance
3. rust-analyzer
4. edamagit

# C++ Theme Color Configuration

## `Quiet Light`

```json
"editor.tokenColorCustomizations": {
    "textMateRules": [
        {
            "scope": "storage.type.class.doxygen",
            "settings": {
                "foreground": "#6A9955"
            }
        },
        {
            "scope": "variable.parameter.cpp,comment.block.documentation.cpp",
            "settings": {
                "foreground": "#6A9955"
            }
        }
    ]
}
```

## Tips

- toggle "Developer: Inspect Editor Tokens and Scopes" to check color of the code block

# Key Bindings

## Go Back

Currently, I map `Go Back` to `F11`.

# Install extention manually

Sometimes, vscode is not able to automatically install the extention manually. To resolve this issue, we can simply download the extention file (with a .vsix exntention name)  and use the command "Extentions: Install from VSIX" from the command pallate.

# Incase that manual intallation fails

1. It seems that the current vscode has a bug. If you disables the manually installed extention (like the GitLens), you would not be able to restart it or install it in any way. 
2. To resolve this issue, go to ```~/.vscode-server/``` folder, delete the extention under the ```~/.vscode-server/extentions/``` folder. 
3. Then remove the correponding json entry under the ```~/.vscode-server/extentions/extentions.json``` file.


