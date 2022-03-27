#!/usr/bin/env php
<?php
/**
 * Returns the gpg secret key ready for commit signing with Git.
 *
 * This contains the gpg secret key ready for commit signing with Git. Uses a
 * regex based function to extract the gpg secret key. This will select only
 * the first matching key.
 *
 * Tested with:
 *      - PHP version 7.3.5 (cli)
 *      - gpg (GnuPG) 2.2.15
 *      - libgcrypt 1.8.4
 *      - macOS 10.14.5
 *
 * @package   CLI_Utilities
 * @author    Michael Treanor  <skeptycal@gmail.com>
 * @copyright 2018 (C) Michael Treanor
 * @license   GPLv3+: GNU GPL version 3 or later <https://gnu.org/licenses/gpl.html>
 * @version   0.5.0
 * @link      https://github.com/skeptycal
 * @return    string
 */

/**
 * Returns the gpg secret key for the current user.
 *
 * @return string
 */
function funcGetGpgKey()
{
    $RE_MATCH_STRING='/^.*sec.{3}rsa4096\/(\w{16}).*/im';
    $GPG_SHELL_COMMAND=`gpg --list-secret-keys --keyid-format LONG`;

    preg_match_all($RE_MATCH_STRING, $GPG_SHELL_COMMAND, $gpg_out);
    return implode('', $gpg_out[1]);
}

function printGpgKey()
{
    echo funcGetGpgKey(), "\n";
}

if ( strpos ( php_sapi_name(), 'cli' ) !== false ) {
    if (in_array ( '--color', $argv )) {
        echo "\n\e[0;31m > GPG Secret (Do Not Share This!!):\e[0m  ";
    }
    printGpgKey();
    return true;
}

/*
 * References:
 * ***************************************************************************
 * Based on GitHub instructions "Telling Git about your signing key"
 * https://help.github.com/articles/telling-git-about-your-signing-key/
 *
 * And: "Generating a new GPG key"
 * https://help.github.com/articles/generating-a-new-gpg-key/
 *
 * This works with 4096 keys:
 *   if you wish to use it with other keys,
 *   replace 'rsa4096' in $RE_MATCH_STRING with the appropriate string
 */

/*
 * Changelog:
 * ***************************************************************************
 *
 * 1.5 use CONSTANTS for preg_match_all parameters for clarity
 * add function printGpgKey to offer both options
 *
 * 1.4 make CLI message optional (pass --color arg)
 *
 * 1.3 Formatting (pass phpcs and phpcbf with php-cs-fixer)
 *
 * 1.2 Add color CLI message with warning
 *
 * 1.1 Refactored and created a function that returns the value
 * instead of a local string. Added CLI codeblock to echo value
 * if run from command line
 *
 * 1.0 Creates a variable that contains the extracted gpg private
 * code from the local key.
 */
