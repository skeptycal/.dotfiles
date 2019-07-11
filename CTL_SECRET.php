#!/usr/bin/env php
<?php /**
       * Get Docker CTL_SECRET from CLI file (must have permission)
       */
    echo `cat ~/.hab/config/cli.toml`;
