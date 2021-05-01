_This is an old thread, but I happened across it and I'm surprised nobody has put up a complete answer yet. So here goes..._

## The Executing a Command Line Script Tutorial!

## **Q:** How do I execute this in Terminal?

> The answer is below, but first ... if you are asking this question, here are a few other tidbits to help you on your way:

## _Confusions and Conflicts:_

### The Path

-   Understanding [The Path][1] (added by [tripleee][2] for completeness) is important. The "path" sounds like a Zen-like [hacker koan][3] or something, but it is simply a list of directories (folders) that are searched automatically when an unknown command is typed in at the command prompt. Some commands, like `ls` may be built-in's, but most commands are actually separate small programs. (This is where the ["Zen of Unix"][4] comes in ... "(i) Make each program do **one** thing well.")

### Extensions

-   Unlike the old DOS command prompts that a lot of people remember, you **_do not need_** an 'extension' (like .sh or .py or anything else), but it helps to keep track of things. It is really only there for humans to use as a reference and most command lines and programs will not care in the least. It won't hurt. If the script name contains an extension, however, you must use it. It is part of the filename.

### Changing directories

-   You do **not** need to be in any certain directory at all for any reason. But if the directory is not on the path (type `echo $PATH` to see), then you must include it. If you want to run a script from the current directory, use `./` before it. This `./` thing means 'here in the current directory.'

### Typing the program name

-   You do **not** need to type out the name of the program that runs the file (BASH or Python or whatever) unless you want to. It won't hurt, but there are a few times when you may get slightly different results.

### SUDO

-   You do **not** need `sudo` to do any of this. This command is reserved for running commands as another user or a 'root' (administrator) user. Running scripts with `sudo` allows much greater danger of screwing things up. So if you don't know the exact reason for using `sudo`, don't use it. Great post [here][5].

### Script location ...

-   A good place to put your scripts is in your `~/bin `folder.
-   You can get there by typing

```sh
# A good place to put your scripts is in your ~/bin folder.

> cd ~/bin # or cd $HOME/bin

> ls -l
```

> You will see a listing with owners and permissions. You will notice that you 'own' all of the files in this directory. You have full control over this directory and nobody else can easily modify it.

If it does not exist, you can create one:

```sh
> mkdir -p ~/bin && cd ~/bin
> pwd

/Users/Userxxxx/bin

```

---

## **A:** To "execute this script" from the terminal on a Unix/Linux type system, you have to do three things:

### 1. **Tell the system the location of the script. (pick one)**

```sh
# type the name of the script with the full path
> /path/to/script.sh

# execute the script from the directory it is in
> ./script.sh

# place the script in a directory that is on the PATH
> script.sh

# ... to see the list of directories in the path, use:
> echo $PATH

# ... or for a list that is easier to read:
> echo -e ${PATH//:/\\n}
# or
> printf "%b" "${PATH//:/\\n}"

```

### 2. **Tell the system that the script has permission to execute. (pick one)**

```sh
# set the 'execute' permissions on the script
> chmod +x /path/to/script.sh

# using specific permissions instead
# FYI, this makes these scripts inaccessible by ANYONE but an administrator
> chmod 700 /path/to/script.sh

# set all files in your script directory to execute permissions
> chmod +x ~/bin/*
```

There is a great discussion of permissions with a cool chart [here][6].

### 3. **Tell the system the type of script. (pick one)**

-   Type the name of the program before the script. (Note: when using this method, the execute(chmod thing above) is not required

```sh
bash /path/to/script.sh
php /path/to/script.php
python3 /path/to/script.py
```

-   Use a _shebang_, which I see you have (`#!/bin/bash`) in your example. If you have that as the first line of your script, the system will use that program to execute the script. No need for typing programs or using extensions.
-   Use a "portable" _shebang_. You can also have the system choose the version of the program that is first in the `PATH` by using `#!/usr/bin/env` followed by the program name (e.g. `#!/usr/bin/env bash` or `#!/usr/bin/env python3`). There are pros and cons as thoroughly discussed [here](https://unix.stackexchange.com/questions/29608/why-is-it-better-to-use-usr-bin-env-name-instead-of-path-to-name-as-my).

> Note: This "portable" shebang may not be as portable as it seems. As with anything over 50 years old and steeped in numerous options that never work out quite the way you expect them ... there is a heated debate. The most recent one I saw that is actually quite different from most ideas is the "portable" perl-bang:

```sh
#!/bin/sh
exec perl -x "$0" "$@"
#!perl
```

[1]: https://stackoverflow.com/a/55342466
[2]: http://https://stackoverflow.com/users/874188/tripleee
[3]: https://simple.wikipedia.org/wiki/Hacker_koan
[4]: https://homepage.cs.uri.edu/~thenry/resources/unix_art/ch01s06.html
[5]: https://unix.stackexchange.com/questions/3063/how-do-i-run-a-command-as-the-system-administrator-root
[6]: https://askubuntu.com/questions/932713/what-is-the-difference-between-chmod-x-and-chmod-755
