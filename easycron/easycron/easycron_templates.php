#!/usr/bin/env php
<?php
/*
###############################################################################
# easycron_template : generic autorun script
#
# author    - Michael Treanor  <skeptycal@gmail.com>
# copyright - 2019 (c) Michael Treanor
# license   - MIT <https://opensource.org/licenses/MIT>
# github    - https://www.github.com/skeptycal
###############################################################################

# see /Volumes/Data/skeptycal/bin/utilities/scripts/crontab.md

*/



$easycron_header = <<<HEADER
#!/usr/bin/env bash
# -*- coding: utf-8 -*-
###############################################################################
# easycron_template : generic autorun script
#
# author    - Michael Treanor  <skeptycal@gmail.com>
# copyright - 2019 (c) Michael Treanor
# license   - MIT <https://opensource.org/licenses/MIT>
# github    - https://www.github.com/skeptycal
###############################################################################

# see /Volumes/Data/skeptycal/bin/utilities/scripts/crontab.md
HEADER;

$ec_template = <<<TEMPLATE
#!/usr/bin/env bash
# -*- coding: utf-8 -*-
###############################################################################
# easycron_template : generic autorun script
#
# author    - Michael Treanor  <skeptycal@gmail.com>
# copyright - 2019 (c) Michael Treanor
# license   - MIT <https://opensource.org/licenses/MIT>
# github    - https://www.github.com/skeptycal
###############################################################################

# see /Volumes/Data/skeptycal/bin/utilities/scripts/crontab.md

EASYCRON_DEFAULT_HOME_DIR="/Volumes/Data/skeptycal"
EASYCRON_INSTALL_DIR="/Volumes/Data/skeptycal/.easycron"

PATH="/Volumes/Data/skeptycal/perl5/bin:/Volumes/Data/skeptycal/bin:/usr/local/opt/coreutils/libexec/gnubin:/Volumes/Data/skeptycal/bin/utilities:/Volumes/Data/skeptycal/bin/utilities/python:/Volumes/Data/skeptycal/bin/utilities/php:/Volumes/Data/skeptycal/bin/utilities/php/includes:/Volumes/Data/skeptycal/bin/utilities/scripts:/Volumes/Data/skeptycal/bin/utilities/apps:/Volumes/Data/skeptycal/.composer/vendor/bin:/Volumes/Data/skeptycal/.composer/vendor/squizlabs/php_codesniffer/bin:/Volumes/Data/skeptycal/.local:/Volumes/Data/skeptycal/.local/bin:/Volumes/Data/skeptycal/.dotfiles:/usr/local/lib/node_modules:/usr/local/Cellar/python/3.7.3/Frameworks/Python.framework/Versions/3.7/Resources/Python.app/Contents/MacOS:/Applications/Postgres.app/Contents/Versions/latest/bin:/Applications/VisualStudioCode.app/Contents/Resources/app/bin:/usr/local/anaconda3/bin:/usr/local/opt/ruby/bin:/usr/local/lib/ruby/gems/2.6.0/bin:/usr/local/go/bin:/usr/local/bin:/usr/bin:/bin:/usr/local/opt:/opt/local/bin:/opt/local/sbin:/usr/local:/usr/local/sbin:/usr/sbin:/sbin:/usr/libexec:/Library/TeX/texbin:/usr/local/share/dotnet:/opt/X11/bin:/Volumes/Data/skeptycal/.dotnet/tools:/Library/Frameworks/Mono.framework/Versions/Current/Commands:/Applications/Postgres.app/Contents/Versions/latest/bin:/Applications/XamarinWorkbooks.app/Contents/SharedSupport/path-bin:/Volumes/Data/skeptycal/perl5/bin:/Volumes/Data/skeptycal/.cargo/bin:/Volumes/Data/skeptycal/.rvm/bin:/Volumes/Data/skeptycal/bin/utilities/git-achievements:"

source "${EASYCRON_DEFAULT_HOME_DIR}/bin/utilities/scripts/standard_script_modules.sh"
DEBUG='1' # set to 1 for debug output
version='1.0.0'

if [[ $DEBUG == '1' ]]; then
    db_echo "DEBUG: $DEBUG"
    db_echo "_script_source: $_script_source"
    db_echo "_script_name: $_script_name"
    db_echo "_bin_path: $_bin_path"
    db_echo "here: $here"
    db_echo "PWD: $PWD"
    db_echo "\$#: $#"
    db_echo "\$0: $0"
    db_echo "\$1: $1"
    db_echo "\$2: $2"
    db_echo "\$(whoami): $(whoami)"
    db_echo "\$(brew --prefix): $(brew --prefix)"
fi
TEMPLATE;

?>
