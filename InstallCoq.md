# Coq work environment set up guide on Ubuntu 18.04

* Install Opam
```bash
apt-get install -y opam m4
```

* Initialize Opam with a OCaml compiler
```bash
opam init -y --compiler=4.07.0
eval `opam config env`
```

* Install Coq (I'll come back later, should be the following)
```bash
opam repo add coq-released http://coq.inria.fr/opam/released
opam install coq.8.9.0 && opam pin add coq 8.9.0
```

* Install ProofGeneral
Copy the following to Emacs config file
```lisp
(require 'package)
(let* ((no-ssl (and (memq system-type '(windows-nt ms-dos))
                    (not (gnutls-available-p))))
       (proto (if no-ssl "http" "https")))
  (add-to-list 'package-archives
               (cons "melpa" (concat proto "://melpa.org/packages/")) t))
(package-initialize)
```
Restart Emacs. Then, run <kbd>M-x package-refresh-contents RET</kbd> followed by
<kbd>M-x package-install RET proof-general RET</kbd> to install and
byte-compile `proof-general`.
