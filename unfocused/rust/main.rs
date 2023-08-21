use std::collections::{HashMap, HashSet};

/// Wtf
///
///
/// sdf
/// sdf
#[derive(Debug)]
struct S {
    i: i32,
}

impl S {
    fn new(i: i32) -> Self {
        Self { i }
    }

    fn dump(&self, arg: i32) {
        println!("{}, {}", self.i, arg);
    }
}

fn foo(x: i32, y: i32) -> i32 {
    return x + y;
}

fn bar(x: i32, y: i32) -> i32 {
    return x + y;
}

fn another_foo() -> Result<u8, ()> {
    Ok(10)
}

fn main() {
    // 1. auto import
    // auto import can be configured, overall, I think this is super useful,
    // as I was stuck adding imports in the mocknet project
    let mut hm = HashMap::new();
    hm.insert(1, 1);

    // 2. auto merge
    // if you import something from the same crate, ra automatically merges the path for yo
    let mut hs = HashSet::new();
    hs.insert(1);

    // 3. expand macro
    // if you select expand macro recursively from the command panel,
    // you can actually see all the expanded macros, which is really good
    // for debugging and learning how macros work in Rust
    println!("fuck {}", hs.get(&1).unwrap());
    let s = S::new(5);
    println!("{:?}", s);

    // 4. extended selection
    // with shift + ctrl + direction button, we can use the extended selection,
    // but it appears to me that this is not useful.
    if true {
    } else {
        let _i = 3;
    }

    // 5. file structure
    // shift+ctrl+o shows the current symbols of the file

    // 6. format string completion
    // I don't know how to use it yet.

    // 7. fuzzy completion and autoimports
    // I can't figure out it yet, it seems that it is explaining
    // how autoimports are implemented.

    // 8. Go to type definition
    // RA's F12 seems to be more powerful than the default Rust mod

    // 9. Go to implementation
    // Ctrl + F12 can go to the implementation block of a struct, enum or trait?

    // 10. Go to Type definition
    // Can't figure it out yet.

    // 11. Hover
    // Nothing special

    // 12. Inlay Hints
    // Probably the most useful feature of RA.

    // 13 Join Lines
    // Select consecutive lines and press ctrl+shift+j, these lines will
    // be merged into one line
    let _i = 3 * 5;
    let _j = 5 * 6;

    // 14 Magic completion
    // Just some special completion features of RA
    let s = S::new(50);
    s.dump(100);

    // Notation: Ctrl+. should be Quick Fix.. in VSCode
    let _wtf = 3;

    // 15 matching brace
    // ctrl + shift + m, automatically goes to the matching brace
    let binary = true;
    match binary {
        true => println!("fuck"),
        false => println!("you"),
    }

    // 16 smart enter for comments and documents
    // Manually add a new keybinding on Enter key through the
    // keybinding.json file, then we can no longer press a lot of
    // enter keys when writing long

    // 17 typing assists?
    let _x = 3;
    let _y = _x;

    // 18 parent modue
    // use Rust Analyzer: Locate parent module to go to the parent module
    // in the current file, we will go to the start of the main.rs file

    // 19 Run
    // Rust Analyzer: run, run binary or the tests
    // this is probably the most useful feature for development

    // 20 syntax highligting
    // it seems that variables will get another color in RA

    // 21 Show Syntax Tree
    // Rust Analyzer: Show Syntax Tree
    // this command can display the syntax tree of the current file
    // which I think can be useful for studying macros?

    // 22 Status
    // Rust Analyzer: Status
    // Show status, which is for debugging purpose of RA itself

    // 23 structral search and replace
    // I think this would be useful for refactoring
    // foo($a, $b) ==>> bar($a, $b) can quickly rename a function
    // however, the function must be resolvable within the current context.
    // The difference from ssr and regular sr in a text editor is that
    // ssr is context-aware, the content that you input into the ssr must be a
    // valid identifer that can be parsed by RA.
    let s = bar(5, 6);

    // 24 workspace symbol search
    // the "most useful" feature of RA
    // triggered by Ctrl + T
    // But I can't see its usefulness right now?
    let mut v = Vec::new();
    v.push(3);

    // 25 a bunch of code actions
    // check out the light bulb whenever possible:)

    // In vscode, there is a Format Document command, whose
    // key shortcut is ctrl + shift + I
    let v = vec![1, 2, 3, 4, 5];
    let res = v
        .iter()
        .map(|i| i + 1)
        .map(|i| i + 100)
        .fold(0, |acc, x| acc + x);
    println!("{}", res);
}

#[cfg(test)]
mod tests {
    #[test]
    fn test_fuck() {
        assert!(1 == 1)
    }

    #[test]
    fn test_2() {
        assert!(3 == 3)
    }

    #[test]
    fn test_wtf() {
        assert!(2 == 2)
    }
}
