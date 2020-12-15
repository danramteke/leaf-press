# LeafPress

Static site generator based on Vapor's [Leaf](https://github.com/vapor/leaf-kit.git). Blog-aware and Markdown aware.

## Install

### Linux 

Statically linked binary. Known to work on Debian and Ubuntu

```
cd /usr/local/bin \
&& curl -L https://github.com/danramteke/leaf-press/releases/download/0.4.14/leaf-press-ubuntu-20.04.tgz | tar xzf - \
&& cd -

leaf-press init
leaf-press build
```

### macOS Big Sur

```
cd /usr/local/bin \
&& curl -L https://github.com/danramteke/leaf-press/releases/download/0.4.14/leaf-press-macos-11.0.tgz | tar xzf - \
&& cd -

leaf-press init
leaf-press build
```

### macOS Catalina

```
cd /usr/local/bin \
&& curl -L https://github.com/danramteke/leaf-press/releases/download/0.4.14/leaf-press-macos-10.15.tgz | tar xzf -
&& cd -

leaf-press init
leaf-press build
```

### Build from source

```
git clone https://github.com/danramteke/leaf-press.git 
cd leaf-press

swift run leaf-press init 
swift run leaf-press build 
```

### Docker

```
docker run -v `pwd`:`pwd` -w `pwd` danramteke/leaf-press:0.4.14 leaf-press build
```

### Mint

Currently having an issue with resources in Mint, so `init` command may not work. The `build` command works fine.

```
mint install danramteke/leaf-press
leaf-press build
```

or

```
mint run danramteke/leaf-press leaf-press build
```

## Getting Started

After the binary is installed locally, `leaf-press init` will scaffold a fresh website for you.

After making changes, run `leaf-press build`

To scaffold a new blog post, with today's date as the default, run `leaf-press new`

Although `leaf-press serve` isn't implemented yet, it prints out a [docker](https://www.docker.com) command pointed at your current output directory.

LeafPress is built on [Leaf](https://github.com/vapor/leaf.git), [Vapor](https://github.com/vapor/vapor.git)'s templating engine. Here is the [Leaf documentionation](https://docs.vapor.codes/4.0/leaf/overview/).

## Config options

Configuration is stored in `leaf-press.yml`. 

- `distDir`: path to output dir, relative to `leaf-press.yml`
- `postsPublishPrefix`: prefix for blog posts. For example if you want them to render to a `posts` folder or a `blog` folder
- `pagesDir`: path to pages directory, relative to `leaf-press.yml`. Pages are standalone pages on the website
- `postsDir`: path to posts directory, relative to `leaf-press.yml`. Posts need to have a date, and are considered chronological.
- `staticFilesDir`: path to static files. These are copied into the output directory without any processing. Useful for images, or for other assets that don't need processing.
- `templatesDir`: path to templates

- `postBuildScript` can be used to run minification or CSS helpers. 


## Example Projects

### GitLab Pages: 

- Daniel Delicious: [GitLab Repo](https://gitlab.com/daniel-delicious/daniel-delicious.gitlab.io) [Website](https://daniel-delicious.gitlab.io)

### GitHub Pages:

None yet

## Development Setup

After cloning the repo, generate an Xcode project with `swift package generate-xcodeproj`. When adding or removing tests, remember to run `swift test --generate-linuxmain` before committing and pushing your changes.

### Branching Strategy

- **main** is the mainline branch. May be unstable.
- **x.x.x** tags are releases. Creating a tag will trigger a release build in github actions and on dockerhub.
