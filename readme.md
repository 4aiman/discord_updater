# Discord updater

This script is designed to alleviate Discord updates on Linux systems.

Yes, there are repos, and snaps, and flatpacks... But fuck those.

Every time there's an update it takes some time for the app to be available.<br>
And on Linux you'll be greeted by that freaking "good news, everyone" window saying there's a new version.<br>

Well, if you know there is, then ***update***. You know, like Telegram or any other normal software does!<br>
Can't seem to be able to run the current version anyway (even though it clearly could run, Discord just hates its users).<br>

So, the idea is quite simple: the script tries to get a new version and updates the app if succeeds.

## Why text files?

1. To keep track of current version.
Script adds 1 to it and tries to update.
2. Some versions are broken, and we need to skip them (at least for now), e.g. ver.99 wants to update to ver.88.

- version.txt holds a single number - the currently installed version.
- skipped_versions.txt holds several numbers each on a separate line - the versions updates should skip.
