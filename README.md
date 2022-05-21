![Swiftmix logo](swiftmix.png)

Swiftmix is a tool aimed to make better use of Swift scripts. Right now there is no decent way to import source files in scripts without using SPM. Swiftmix can solve this problem while requiring little to no modifications to existing scripts.

## How to install

There are two ways to install Swiftmix:

1. Clone the repo and run `make install`
2. With Homebrew installed run `brew install mrtokii/formulae/swiftmix`

## How it works

In short, you can now use `swiftmix` command instead of `swift` anywhere. There are no settings or parameters.

Swiftmix acts as a wrapper for `swift` interpreter. It scans for `import` directives and tries to find a file with corresponding name in current directory. Then Swiftmix inserts file's contents in place (only once, similar to Objective-C `#import`) and also deals with hashbangs inside imported files. Finally, with all the source code combined together it runs `swift` interpreter.

## Examples

Consider having a file `say.swift`:

```swift
#!/usr/bin/env swiftmix

func say(_ str: String) {
    print("Say: \(str)")
}
```

And main script file `myscript.swift`:

```swift
#!/usr/bin/env swiftmix

import say.swift

say("Hello \(CommandLine.arguments[1])")
```

To run the main script:

```bash
$ swiftmix myscript.swift World
Say: Hello World
```

Alternatively, you can run the script directly, as it contains `#!/usr/bin/env swiftmix` line:

```bash
$ ./myscript.swift World
Say: Hello World
```
