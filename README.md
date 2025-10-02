# iCloud Utilities

The scripts included here are designed to make your life easier when managing iCloud files located on your macOS machines.

## Checking pending uploads

Sometimes you put some big files in your iCloud folder and want to check the upload progress.

To simplify this task you can use the provided `check-pending.sh` script.

## Listing files that can be evicted

Sometimes you end up having files in your machine that you are not really using. 
macOS does a good job releasing the space used by them when needed,
but sometimes you just want to get rid of them manually. This can be done with
the `brctl evict` command.

To see if a folder contains files that can be evicted, you can issue use the provided
`ls-dataless.sh` script:

> Sintax: 
>    ./ls-dataless.sh folder_name [--paged] [--usecolor]

After checking for a given folder and deciding that you really want to get rid of the files on
your machine (while keeping them on iCloud). You may use the `brctl evict` command as follows:

```shell
# Evict files contained inside myfolder_name folder
brctl evict myfolder_name
```
