# Installation

## Install OCaml
The toolchain of OCaml is very similar to Rust. Making a local installation is very user-friendly. 

1. Use the following command to install opam:  
```shell
bash -c "sh <(curl -fsSL https://raw.githubusercontent.com/ocaml/opam/master/shell/install.sh)"
```

2. Init opan with:  
```shell
opam init
```

3. Since we will use Coq, switch to OCaml 4.14.2:  
```shell
opam switch create 4.14.2
```

4. Install utility packages as specified on the OCaml official website:  
```shell
opam install dune merlin ocaml-lsp-server odoc ocamlformat utop dune-release menhir
```

## Install Coq
Since we will use compcert, so we install Coq 8.19 with the following command:  
```shell
opam pin add coq 8.19.0
```

## Compile compcert

1. Configure compcert with:   
```shell
./configure --prefix /home/djp/tmp x86_64-linux
```  
The `--prefix /home/djp/tmp` to specify the prefix directory for installing compcert tools.

2. Build the compcert with:
```shell
make all -j 4
```

3. Before using the `ccomp` binary, remember to add `/home/djp/tmp/lib` to the ld library path with:  
```shell
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:~/tmp/lib
```



