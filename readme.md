# About the project

_These are my dotfiles, don't use it unless you know what each line of code means._

_The dotfiles are managed by [chezmoi](https://www.chezmoi.io/)_

```bash
$ sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply $GITHUB_USERNAME
```

## Requirements
- Machine (Endeavour OS Linux distro).
- Internet.
- Power-user experience.

## Usage

### Post-installation guide
- Don't skip the post-installation welcome : 
 * update mirrors
 * system update

### Apps
Apps are installed automatically with scripts. Some apps need to be installed 
manually for the moment being. 
* Min Browser
* Linked journaling app 

### Utils

- Configure [gpg-key](https://docs.github.com/en/authentication/managing-commit-signature-verification/generating-a-new-gpg-key)
  for github signing commits.
* Use DaddyTimeMono NF for normal usage. 
* Use [maple-font](https://github.com/subframe7536/Maple-font/releases) for developer/ programming usage.

## Note

* The dotfiles are in constant change. (WIP)
* I will probably use Endeavour OS in the future. (once used, it will be deleted).
I use actually fedora 39, the scripts don't work for fedora.
