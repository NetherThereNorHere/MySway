#!/bin/bash
check() { return 0; }
depends() { echo "plymouth"; }
install() { inst_hook pre-udev 99 "$moddir/plymouth-blank.sh"; }
