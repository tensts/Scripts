According to NetworkManager(8) man:

`Each script should be a regular executable file owned by root. Furthermore, it must not be writable by group or other, and not setuid.`

That being said after placing it in directory we have to:

```
#> chown root: 99-wireless-down-when-ethernet-up
#> chmod 744 99-wireless-down-when-ethernet-up
```
