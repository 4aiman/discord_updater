cd "$HOME/dev/discord_updater/"
discord_version=`cat version.txt`
mapfile -t skipped_versions < skipped_versions.txt

new_discord_version=$((discord_version + 1))

for skipped_version in "${skipped_versions[@]}"
do   
   if [ $skipped_version == $new_discord_version ]; then
      echo "skipping version ${skipped_version} ?"
      new_discord_version=$((new_discord_version + 1))      
   fi;    
done


wget "https://stable.dl2.discordapp.net/apps/linux/0.0.$new_discord_version/discord-0.0.$new_discord_version.tar.gz"
if [ -f "discord-0.0.$new_discord_version.tar.gz" ]; then
    rm -rf "Discord"
    tar -xvf "discord-0.0.$new_discord_version.tar.gz" 
    cp -r -T "Discord" "$HOME/Рабочий стол/Apps/Discord"
    echo $new_discord_version > version.txt    
fi

"$HOME/Рабочий стол/Apps/Discord/Discord"
