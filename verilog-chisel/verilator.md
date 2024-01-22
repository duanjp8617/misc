# Setting up the vscode to work with verilator

## The ms C++ extention

Verilator compiles .v files to cpp models. To work with verilator cpp models, we need a C++ extention to index the cpp source code generaed by verilator.

We use the ms c++ extention because it is eaiser to set than clangd (which can be referred from my tvm_cpu configuration). 

After installing the ms c++ extention, we need to configure the header search path. All we need to do is to 
```/usr/local/share/verilator/include``` to the ms c++ extention's include search path:
* We can use the quick fixex to add the search path
* We can also manaully create a ```.vscode``` directory, and add the following content to the ```c_cpp_properties.json``` file
```json
{
    "configurations": [
        {
            "name": "Linux",
            "includePath": [
                "${workspaceFolder}/**",
                "/usr/local/share/verilator/include"
            ],
            "defines": [],
            "compilerPath": "/usr/bin/gcc",
            "cStandard": "c17",
            "cppStandard": "gnu++17",
            "intelliSenseMode": "linux-gcc-x64"
        }
    ],
    "version": 4
}
```

# How verilator can be learned

