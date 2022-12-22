1. The mint package requires Pygments. So we need to first install Pygments with 
```shell
pip install Pygments
```

2. Then, add the following code to import the mint package and a nice-looking code font:
```latex
\usepackage{minted}
\usepackage{inconsolata}
```

3. Finally, to use mint with vscode, we need to to pass an extra argument when invoking pdflatex. To do that, we can 
add the following code to the user configuration json file of vscode:
```json
"latex-workshop.latex.tools": [
    {
        "name": "latexmk",
        "command": "latexmk",
        "args": [
            "-shell-escape",
            "-synctex=1",
            "-interaction=nonstopmode",
            "-file-line-error",
            "-pdf",
            "-outdir=%OUTDIR%",
            "%DOC%"
        ],
        "env": {}
    },
]
```