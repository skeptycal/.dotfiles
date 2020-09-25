
# Reference http://www.faqs.org/docs/Linux-mini/Xterm-Title.html#ss3.1

class bcolors:
    HEADER = '\033[95m'
    OKBLUE = '\033[94m'
    OKGREEN = '\033[92m'
    WARNING = '\033[93m'
    FAIL = '\033[91m'
    ENDC = '\033[0m'
    BOLD = '\033[1m'
    UNDERLINE = '\033[4m'

# echo -n "\033]0;${USER}@${HOST}\007"


FMT_TERMINAL_TITLE_STRING: str = '\033]0;{}\007'

print(FMT_TERMINAL_TITLE_STRING.format('Mike'))

''' 3. Dynamic titles

    Many people find it useful to set the title of a terminal to
    reflect dynamic information, such as the name of the host the user is logged
    into, the current working directory, etc.

3.1 xterm escape sequences

    Window and icon titles may be changed in a running
    xterm by using XTerm escape sequences. The following sequences are useful
    in this respect:

        ESC]0;stringBEL -- Set icon name and window title to string
        ESC]1;stringBEL -- Set icon name to string
        ESC]2;stringBEL -- Set window title to string

    where ESC is the escape character (\033), and BEL is the bell character
    (\007).

    Printing one of these sequences within the xterm will cause the window or
    icon title to be changed.

    Note: these sequences apply to most xterm derivatives, such as nxterm,
    color-xterm and rxvt. Other terminal types often use different escapes;
    see the appendix for examples. For the full list of xterm escape sequences
    see the file ctlseq2.txt, which comes with the xterm distribution, or
    xterm.seq, which comes with the rxvt distribution.

3.2 Printing the escape sequences

    For information that is constant throughout the lifetime of this shell, such
    as host and username, it will suffice to simply echo the escape string in
    the shell rc file:

        echo -n "\033]0;${USER}@${HOST}\007"

    should produce a title like
    username@hostname, assuming the shell variables $USER and $HOST are set
    correctly. The required options for echo may vary by shell (see examples below).
    For information that may change during the shell's lifetime, such as current
    working directory, these escapes really need to be applied every time the prompt
    changes. This way the string is updated with every command you issue and can
    keep track of information such as current working directory, username, hostname,
    etc. Some shells provide special functions for this purpose, some don't and we
    have to insert the title sequences directly into the prompt string. This is
    illustrated in the next section.


4.1 zsh
    zsh provides some functions and expansions, which we will use:

        precmd ()   a function which is executed just before each prompt
        chpwd ()    a function which is executed whenever the directory is changed
        \e          escape sequence for escape (ESC)
        \a          escape sequence for bell (BEL)
        %n          expands to $USERNAME
        %m          expands to hostname up to first '.'
        %~          expands to directory, replacing $HOME with '~'

    There are many more expansions available: see the zshmisc man page.

    Thus, the following will set the xterm title to "username@hostname: directory":

        case $TERM in
            xterm*)
                precmd () {print -Pn "\e]0;%n@%m: %~\a"}
                ;;
        esac

    This could also be achieved by using chpwd() instead of precmd(). The print
    builtin works like echo, but gives us access to the % prompt escapes.

    '''
