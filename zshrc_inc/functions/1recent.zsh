
	recent () { cat <<- EOF
		${LIME}
		--------------------------------------------------------${CANARY}
		Selected recently added utilities:
		${GREEN:-}
		Recently added:
			binit               - link a file to ~/bin and and chmod +x it
			bump                - update repo version (and changelog...)
			checkpath           - display and check \$PATH,
			checkpath.py        - display and check \$PATH (alternate version),
			do_over [target]    - repeat something over and over ... and over
			fd                  - find "\$PWD" -type d -name "\$1";
			ff                  - find "\$PWD" -type f -name "\$1";
			getURL              - gets url of active Chrome tab
			gitit               - add and commit all changes
			log_urls            - logs urls from chrome constantly
			login_message       - this message!!
			ping_avg            - average of ping times over COUNT attempts
			pm 						- colorize files with pygmentize
			preman              - open man pages nicely formatted in Preview
			pret 					- format all possible files with Prettier
			quickpret           - prettier (write, ignore unknown, hide errors)
			rc                  - repo clean (cache and temp files)
			rebrew			- upgrade all brew packages
			repip               - repair and update pip packages in current env
			space [DEVICE]      - space remaining on drive
			sunday              - weekly maintenance scripts
			sysctl -a           - display a ton of system settings
			update_git_dirs     - update all git repos ${WARN}${REVERSED}DANGER${RESET}${LIME}
			versions            - to display program versions
		EOF
		}