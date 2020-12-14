# leaf-press and LeafPressKit

Static site generator based on Vapor's [Leaf](https://github.com/vapor/leaf-kit.git). Blog-aware and Markdown aware.


## Install

### Mint

```
mint install danramteke/leaf-press
leaf-press build
```

or

```
mint run danramteke/leaf-press leaf-press build
```

### Pre-built Binaries

#### Linux 

Statically linked binary. Known to work on Debian and Ubuntu

```
curl -L https://github.com/danramteke/leaf-press/releases/download/0.4.7/leaf-press-ubuntu-20.04.tgz | tar xzf -
./leaf-press build
```

#### macOS Big Sur

```
curl -L https://github.com/danramteke/leaf-press/releases/download/0.4.7/leaf-press-macos-11.0.tgz | tar xzf -
./leaf-press build
```

#### macOS Catalina

```
curl -L https://github.com/danramteke/leaf-press/releases/download/0.4.7/leaf-press-macos-10.15.tgz | tar xzf -
./leaf-press build
```

### Build from source

```
git clone https://github.com/danramteke/leaf-press.git && cd leaf-press
swift build 
```

## Getting Started

After the binary is installed locally, `leaf-press init` will scaffold a fresh website for you.

After making changes, run `leaf-press build`

Although `leaf-press serve` isn't implemented yet, it prints out a [docker](https://www.docker.com) command pointed at your current output directory.

LeafPress is built on [Leaf](https://github.com/vapor/leaf.git), [Vapor](https://github.com/vapor/vapor.git)'s templating engine. Here is the [Leaf documentionation](https://docs.vapor.codes/4.0/leaf/overview/).

## Config options

- `postBuildScript` can be used to run minification or CSS helpers. 


## Example Projects

GitLab Pages: 

- Repo: <https://gitlab.com/daniel-delicious/daniel-delicious.gitlab.io>
- Website: <https://daniel-delicious.gitlab.io>

## Development Setup

After cloning the repo, generate an Xcode project with `swift package generate-xcodeproj`
