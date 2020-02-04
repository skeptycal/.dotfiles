# Macbook Pro Setup

---

[![netlify badge](https://api.netlify.com/api/v1/badges/416b8ca3-82db-470f-9adf-a6d06264ca75/deploy-status)](https://app.netlify.com/sites/mystifying-keller-ab5658/deploys) [![Build Status](https://travis-ci.com/skeptycal/.dotfiles.svg?branch=dev)](https://travis-ci.com/skeptycal/.dotfiles) [![test coverage](https://img.shields.io/badge/test_coverage-100%25-6600CC.svg?logo=Coveralls&color=3F5767)](https://coveralls.io) [![CII Best Practices](https://bestpractices.coreinfrastructure.org/projects/3454/badge)](https://bestpractices.coreinfrastructure.org/projects/3454)

[![GitHub Pipenv locked Python version](https://img.shields.io/badge/Python-3.8-yellow?color=3776AB&logo=python&logoColor=yellow)](https://www.python.org/) [![nuxt.js](https://img.shields.io/badge/nuxt.js-2.10.2-35495e?logo=nuxt.js)](https://nuxtjs.org/) [![macOS Version](https://img.shields.io/badge/macOS-10.15%20Catalina-orange?logo=apple)](https://www.apple.com)

[![code style: prettier](https://img.shields.io/badge/code_style-prettier-ff69b4.svg?logo=prettier)](https://github.com/prettier/prettier) [![License](https://img.shields.io/badge/License-MIT-darkblue)](https://skeptycal.mit-license.org/1976/) [![Contributor Covenant](https://img.shields.io/badge/Contributor%20Covenant-v1.4%20adopted-ff69b4.svg)](CODE_OF_CONDUCT.md)

![Twitter Follow](https://img.shields.io/twitter/follow/skeptycal.svg?style=social) ![GitHub followers](https://img.shields.io/github/followers/skeptycal.svg?label=GitHub&style=social)

## System setup for MacBook Pro using Mojave, Bash, and Python Development

This is my software development setup for a MacBook Pro (mid-2015, 16g ram, 256g SSD). It is the setup I currently use and may change frequently. I am a dabbler in many arts ... and far from expert in most areas. Take it for what it is worth to you.

**Please feel free to offer suggestions and changes** (contribution instructions below). I have been coding for many years, but mostly as a side activity ... as a tool to assist me in other endeavors ... so I have not had the 'hard time' invested of constant coding that many of you have.

> Copyright © 2018-2019 [Michael Treanor](https:/skeptycal.github.com)

> Many original settings © 2018 [Mathias Bynens](https://mathiasbynens.be/)

> [MIT License](https://opensource.org/licenses/MIT) - enjoy ...

## Installation

**Warning:** If you want to use this setup, you should fork this repository, review the code, and make changes to suit your needs.

If you aren't sure, don't use it! This setup works for me for what I do. Don’t blindly use my settings unless you know what that entails. It could make your system inoperable or at least very annoying to use! Use at your own risk!

### Using Git and the bootstrap script

You can clone the repository wherever you want. (I like to keep it in `~/.dotfiles`) The bootstrapper script will pull in the latest version and copy the files to your home folder.

```bash
git clone https://github.com/skeptycal/dotfiles.git && cd .dotfiles && source bootstrap.sh
```

To update, `cd` into your local `.dotfiles` repository and then:

```bash
source bootstrap.sh
```

Alternatively, to update while avoiding the confirmation prompt:

```bash
set -- -f; source bootstrap.sh
```

### Specify the `$PATH`

If `~/.path` exists, it will be sourced along with the other files, before any feature testing (such as [detecting which version of `ls` is being used](https://github.com/mathiasbynens/dotfiles/blob/aff769fd75225d8f2e481185a71d5e05b76002dc/.aliases#L21-26)) takes place.

Here’s an example `~/.path` file that adds `/usr/local/bin` to the `$PATH`:

```bash
export PATH="/usr/local/bin:$PATH"
```

### Add custom commands without creating a new fork

If `~/.extra` exists, it will be sourced after the other files. You can use this to add a few custom commands without the need to fork this entire repository, or to add commands you don’t want to commit to a public repository.

My `~/.extra` looks something like this:

```bash
# Git credentials
# Not in the repository, to prevent people from accidentally committing under my name
GIT_AUTHOR_NAME="Michael Treanor"
GIT_COMMITTER_NAME="$GIT_AUTHOR_NAME"
git config --global user.name "$GIT_AUTHOR_NAME"
GIT_AUTHOR_EMAIL="skeptycal@gmail.com"
GIT_COMMITTER_EMAIL="$GIT_AUTHOR_EMAIL"
git config --global user.email "$GIT_AUTHOR_EMAIL"
```

Since it is sourced last, you could also use `~/.extra` to override settings, functions and aliases from my dotfiles repository. It’s probably better to [fork this repository](https://github.com/mathiasbynens/dotfiles/fork) instead, though.

### Sensible macOS defaults

When setting up a new Mac, you may want to set some sensible macOS defaults:

```bash
./.macos
```

### Install Homebrew formulae

When setting up a new Mac, you may want to install some common [Homebrew](https://brew.sh/) formulae (after installing Homebrew, of course):

```bash
./brew.sh
```

Some of the functionality of these dotfiles depends on formulae installed by `brew.sh`. If you don’t plan to run `brew.sh`, you should look carefully through the script and manually install any particularly important ones. A good example is Bash/Git completion: the dotfiles use a special version from Homebrew.

## Feedback

Suggestions/improvements
[welcome](https://github.com/skeptycal/dotfiles/issues)!

## Author

[![twitter/skeptycal](https://s.gravatar.com/avatar/b939916e40df04f870b03e0b5cff4807?s=80)](http://twitter.com/skeptycal "Follow @skeptycal on Twitter")

[**Michael Treanor**](https://www.skeptycal.com)

## Based primarily on the open source work of:

[![twitter/mathias](http://gravatar.com/avatar/24e08a9ea84deb17ae121074d0f17125?s=70)](http://twitter.com/mathias "Follow @mathias on Twitter")

[Mathias Bynens](https://mathiasbynens.be/)

## Thanks to…

-   @ptb and [his _macOS Setup_ repository](https://github.com/ptb/mac-setup)
-   [Ben Alman](http://benalman.com/) and his [dotfiles repository](https://github.com/cowboy/dotfiles)
-   [Cătălin Mariș](https://github.com/alrra) and his [dotfiles repository](https://github.com/alrra/dotfiles)
-   [Gianni Chiappetta](https://butt.zone/) for sharing his [amazing collection of dotfiles](https://github.com/gf3/dotfiles)
-   [Jan Moesen](http://jan.moesen.nu/) and his [ancient `.bash_profile`](https://gist.github.com/1156154) + [shiny _tilde_ repository](https://github.com/janmoesen/tilde)
-   [Lauri ‘Lri’ Ranta](http://lri.me/) for sharing [loads of hidden preferences](http://osxnotes.net/defaults.html)
-   [Matijs Brinkhuis](https://matijs.brinkhu.is/) and his [dotfiles repository](https://github.com/matijs/dotfiles)
-   [Nicolas Gallagher](http://nicolasgallagher.com/) and his [dotfiles repository](https://github.com/necolas/dotfiles)
-   [Sindre Sorhus](https://sindresorhus.com/)
-   [Tom Ryder](https://sanctum.geek.nz/) and his [dotfiles repository](https://sanctum.geek.nz/cgit/dotfiles.git/about)
-   [Kevin Suttle](http://kevinsuttle.com/) and his [dotfiles repository](https://github.com/kevinSuttle/dotfiles) and [macOS-Defaults project](https://github.com/kevinSuttle/macOS-Defaults), which aims to provide better documentation for [`~/.macos`](https://mths.be/macos)
-   [Haralan Dobrev](https://hkdobrev.com/)
-   Anyone who [contributed a patch](https://github.com/mathiasbynens/dotfiles/contributors) or [made a helpful suggestion](https://github.com/mathiasbynens/dotfiles/issues)
