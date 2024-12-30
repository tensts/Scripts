# My tools

- `clearramcache` - clears RAM cache ;)
- `cmount` - mount LUKS drive in directory
- `download-whole-website` - downloads website with all linking files (`<a>`) _not recursive_
- `getddos` - prints graph with number of requests from apache2 log file
- `wipe` - secure wipe file/block device
- `rename_files` - rename file to `[a-zA-Z0-9_-]` pattern and _optionaly_ checks extension (by mime-type) and rename it too. _not recursive_

- `etc/NetworkManager/dispatcher.d/99-wireless-down-when-ethernet-up` - as filename describes it will turn off wifi when network cable is connected, and vice versa (tested on Debian 9)
- `make_ansible_playbook.sh` - creates skeleton of Ansible playbook directories structure (with roles)
- `remove_exif_data.py` - removes exif data from image file
- `randomize_prompt_color.sh` - generates random color bash prompt (using for easy identify on what host am I right now)
- `mongo2xlsx` - saves data from all database collections to xlsx file (more details in README)
- `build-ipxe-efi-iso.sh` - create bootable iso image for efi pxe boot (tested on vbox6.1)"
- `ftp.py` - simple FTP server
- `iptables-timer.sh` - iptables failover, will restart `/etc/iptables/rules.v4` after time (in case of lockout due to iptables changes)
