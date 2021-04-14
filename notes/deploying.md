`rsync [options] src/ user@domain.com:/path/to/site/file/root`

`/` at end of `src/` says copy contents of `src` and not `src` itself

## My Default Options (`-avz`)

- `-a --archive`: Recursive, handles symlinks, perms, times, group, owner
- `-v --verbose`
- `-z --compress`

## Other Options
- `--delete`: Delete files from dest that are not in source.
- `--stats`
- `-h --human-readable`
- `-n —dry-run`
