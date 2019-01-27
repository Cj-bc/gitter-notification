# gitter-notifier -- pop up notification whe you got new post at gitter [mac only]

**This works only on macOS**

# dependencies

- [mattn/gitter-cli](https://github.com/mattn/gitter-cli)
- [julienXX/terminal-notifier](https://github.com/julienXX/terminal-notifier)

# usage(v0.1.0)

- start daemon: `./gitter-notifier.sh <room_name>`

# installation

## dependency

`terminal-notifier` can be installed via homebrew

```
$ brew install terminal-notifier
```

`gitter-cli` can be installed via go

```
$ go get github.com/mattn/gitter-cli
```

## gitter-notifier itself

For now I don't pripair any installation.
I'll make homebrew formula later.

Please clone this and execute script directly

```
$ git clone https://github.com/Cj-bc/gitter-notifier
$ cd gitter-notifier
$ ./gitter-notifier.sh <room_name>
```
