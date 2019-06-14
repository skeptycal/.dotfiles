#!/usr/bin/env php
<?php
/**
 * Git_gpg.php - return private gpg key
 *
 * Based on GitHub instructions "Telling Git about your signing key"
 * https://help.github.com/articles/telling-git-about-your-signing-key/
 *
 * And: "Generating a new GPG key"
 * https://help.github.com/articles/generating-a-new-gpg-key/
 *
 * PHP version 7.3.1 (cli) (built: Jan 10 2019 13:15:37)
 *
 * gpg (GnuPG) 2.2.12
 * libgcrypt 1.8.4
 * License GPLv3+: GNU GPL version 3 or later
 * <https://gnu.org/licenses/gpl.html>
 * This is free software: you are free to change and redistribute it.
 * There is NO WARRANTY, to the extent permitted by law.
 *
 * @category  CLI_Utility
 * @package   Git_Gpg
 * @author    Michael Treanor  <skeptycal@gmail.com>
 * @copyright 2018 (C) Michael Treanor
 * @license   GPLv3+: GNU GPL version 3 or later <https://gnu.org/licenses/gpl.html>
 * @version   GIT: 2.20.1
 * @link      https://github.com/skeptycal
 */

// *****************************************************************************

// Use regex to extract secret key from gpg function

// This works with 4096 keys ... if you wish to use it with other keys,
//   replace 'rsa4096' below with the appropriate number
preg_match_all(
    '/^.*sec.{3}rsa4096\/(\w{16}+)/im',
    `gpg --list-secret-keys --keyid-format LONG`,
    $gpg_out
);

// convert $gpg_out[1] to string $gpg_code 
// ? (this variable is used in some modules that include this script)
$gpg_code = implode("", $gpg_out[1]);

// return private key
echo $gpg_code;
