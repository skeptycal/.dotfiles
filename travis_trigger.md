## Travis CI command line utility <img align="right" width="150" height="150" src="https://camo.githubusercontent.com/ea6828045b2dcd9770732d272586c5567bedfef3/687474703a2f2f61626f75742e7472617669732d63692e6f72672f696d616765732f7472617669732d6d6173636f742d32303070782e706e67">

![Twitter Follow](https://img.shields.io/twitter/follow/skeptycal.svg?style=social) ![GitHub followers](https://img.shields.io/github/followers/skeptycal.svg?label=GitHub&style=social)

> Michael Treanor

> [skeptycal.com](https://www.skeptycal.com)

> MIT License

It is handy to trigger a Travis CI build from the command line. They have setup a great way using the [Travis CLI][1], as described in the [documentation][2]. There are **_many_** other interesting features in the CLI that make it worth looking at. Much of this information came from this [Stack Overflow][4] post.

Make sure you have at least [Ruby][3] 1.9.3 (2.0.0 recommended) installed. _I tested on macOS (10.14.6 Beta) but it is available on Windows and Linux, also._

```sh
# check ruby version
$ ruby -v
ruby 2.6.3p62 (2019-04-16 revision 67580) [x86_64-darwin18]

# if ruby > 1.9.3, install travis CLI
gem install travis -v 1.8.10 --no-rdoc --no-ri

# the command line options did not work for me
# I had to use:
# gem install travis -v 1.8.10

# login to your account
$ travis login --github-token --auto

# get a token and save (HIDE) it somewhere
$ travis token
Your access token is xxxxxxx-xxxxxxxxxxxxxx
```

You can keep this token in an environment variable `TRAVIS_TOKEN`. **_Make sure the file it is stored in is NOT version controlled publicly!_**

I created a file called `travis.private` and use `source` to load it from my `.bash_profile`. On my system, files with the word private as any part of their name are excluded from VC by the global `.gitignore.`

```bash
#!/usr/bin/env false bash
# -*- coding: utf-8 -*-
TRAVIS_TOKEN='xxxxxxx-xxxxxxxxxxxxxx'
export TRAVIS_TOKEN

```

Then, put this code in the .bash_profile or equivalent and have it spit out a summary so I know it is working right:

```bash
source /path/to/secret/.file/travis_private.sh
travis login -g "$TRAVIS_TOKEN"
echo ''
echo "Travis CI:"
echo "$(travis accounts)"

Travis CI:
skeptycal (Michael Treanor): subscribed, 209 repositories

```

I use this function to submit triggers:

```bash
function travis_trigger() {
local org=$1 && shift
local repo=$1 && shift
local branch=\${1:-master} && shift

     body="{
             \"request\": {
               \"branch\": \"${branch}\"
              }
           }"

     curl -s -X POST \
          -H "Content-Type: application/json" \
          -H "Accept: application/json" \
          -H "Travis-API-Version: 3" \
          -H "Authorization: token $TRAVIS_TOKEN" \
          -d "$body" \
          "https://api.travis-ci.org/repo/${org}%2F${repo}/requests"

}
```

Reference: https://stackoverflow.com/a/40223297/9878098

[1]: https://github.com/travis-ci/travis.rb
[2]: https://docs.travis-ci.com/user/triggering-builds
[3]: http://www.ruby-lang.org/en/downloads/
[4]: https://stackoverflow.com/a/40223297
