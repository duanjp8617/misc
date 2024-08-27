Rust analyzer uses a special crate called ```cargo-metadata``` to fetch the metadata.  
Under this context, we have two ways to accelerate the metadata fetching of rust-analyzer:

**First:**  
Use the ustc cargo mirror, by adding the following content to the ```~/.cargo/config.toml```:
```toml
[source.crates-io]
replace-with = 'ustc'

[source.ustc]
registry = "sparse+https://mirrors.ustc.edu.cn/crates.io-index/"
```

**Second:**  
Launch the clash proxy (assuming that the proxy listens at localhost:7890), and then configure the cargo to use the proxy by adding the following content to the ```~/.cargo/config.toml```:
```toml
[http]
proxy = "http://127.0.0.1:7890"
``` 