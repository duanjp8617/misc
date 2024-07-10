# configure rustfmt.toml

1. Many rustfmt features require nightly build. So we first install nightly toolchain with:
```shell
rustup toolchain install nightly
```

2. Then, add the following flag to the rustfmt control section in rust-analyzer\
```shell
+nightly
```

3. Add a file named `rustfmt.toml`. If we want to enable comment wrap, add the following lines to this file:
```shell
unstable_features = true
wrap_comments = true
comment_width = 80
```

