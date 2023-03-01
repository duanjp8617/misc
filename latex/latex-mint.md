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

4. Then you can add nice-looking source code to latex source file. A basic tutorial can be found on: https://www.overleaf.com/learn/latex/Code_Highlighting_with_minted

5. use [linenos,xleftmargin=\parindent] to align the line numbers to the left margin 

6. https://tex.stackexchange.com/questions/280590/work-around-for-minted-code-highlighting-in-arxiv
