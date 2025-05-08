cd "$HOME/dev/discord_updater/"
discord_version=`cat version.txt`
mapfile -t skipped_versions < skipped_versions.txt

new_discord_version=$((discord_version + 1))
echo "Trying to get a new version of Discord: v${new_discord_version}"

for skipped_version in "${skipped_versions[@]}"
do   
   if [ $skipped_version == $new_discord_version ]; then
      echo "Skipping version ${skipped_version}"
      new_discord_version=$((new_discord_version + 1))      
   fi;    
done

echo "Version needed (after skips): v${new_discord_version}"

wget "https://stable.dl2.discordapp.net/apps/linux/0.0.$new_discord_version/discord-0.0.$new_discord_version.tar.gz"
if [ -f "discord-0.0.$new_discord_version.tar.gz" ]; then
    echo "Removing the old version from update dir"
    rm -rf "Discord"
    echo "Removing the old version from the install dir"
    rm -rf "$HOME/Рабочий стол/Apps/Discord"
    echo "Unpacking the update"
    tar -xvf "discord-0.0.$new_discord_version.tar.gz"     
    echo "Copying everything to the install dir"
    cp -r -T "Discord" "$HOME/Рабочий стол/Apps/Discord"
    echo "Updating version.txt with the nes version: v${new_discord_version}"
    echo $new_discord_version > version.txt    
else
    echo "No version upgrade happened"
    if [ ! -d "$HOME/Рабочий стол/Apps/Discord" ]; then
      echo "Copying the old version to the install dir (dunno why it was missing)"
      mkdir -p "$HOME/Рабочий стол/Apps/Discord/"
      cp -r -T "Discord" "$HOME/Рабочий стол/Apps/Discord/"
    fi
fi


"$HOME/РабочийCтол/Apps/Discord/Discord"

