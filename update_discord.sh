cd "$HOME/dev/discord_updater/"
discord_version=`cat version.txt`
mapfile -t skipped_versions < skipped_versions.txt

new_discord_version=$((discord_version + 1))
echo "[4dis] Trying to get a new version of Discord: v${new_discord_version}"

for skipped_version in "${skipped_versions[@]}"
do   
   if [ $skipped_version == $new_discord_version ]; then
      echo "[4dis] Skipping version ${skipped_version}"
      new_discord_version=$((new_discord_version + 1))      
   fi;    
done

echo "[4dis] Version needed (after skips): v${new_discord_version}"

wget "https://stable.dl2.discordapp.net/apps/linux/0.0.$new_discord_version/discord-0.0.$new_discord_version.tar.gz"
if [ -f "discord-0.0.$new_discord_version.tar.gz" ]; then
    echo "[4dis] Removing the old version from update dir"
    rm -rf "Discord"
    echo "[4dis] Removing the old version from the install dir"
    rm -rf "$HOME/РабочийCтол/Apps/Discord"
    echo "[4dis] Unpacking the update"
    tar -xvf "discord-0.0.$new_discord_version.tar.gz"     
    echo "[4dis] Copying everything to the install dir"
    cp -r -T "Discord" "$HOME/РабочийCтол/Apps/Discord"
    echo "[4dis] Updating version.txt with the nes version: v${new_discord_version}"
    echo $new_discord_version > version.txt    
else
    echo "[4dis] No version upgrade happened"
    if [ ! -d "$HOME/РабочийCтол/Apps/Discord" ]; then
      echo "[4dis] Copying the old version to the install dir (dunno why it was missing)"
      mkdir -p "$HOME/РабочийCтол/Apps/Discord/"
      cp -r -T "Discord" "$HOME/РабочийCтол/Apps/Discord/"
    fi
fi


TEMP_FILE=$(mktemp)
echo "[4dis] Created a temp file to monitor the output: ${TEMP_FILE}"


echo "[4dis] Launching Discord..."
"$HOME/РабочийCтол/Apps/Discord/Discord" > "$TEMP_FILE" 2>&1 &

# Get the process ID of the app
APP_PID=$!

echo "[4dis] App ID is ${APP_PID}"

# Function to check if the string "update-manually" is in the output
check_output() {
    # Use tail to follow the output of the temporary file and grep to filter the specific string
    tail -f "$TEMP_FILE" | grep "update-manually" | while read -r line; do
        # Extract the version number using awk and sed
        version_number=$(echo "$line" | awk '{print $NF}')
        echo "[4dis] Version number extracted: $version_number"
        # Store the version number in a variable
        VERSION_NUMBER=$version_number
        new_discord_version2=$((VERSION_NUMBER + 1))
        echo $VERSION_NUMBER > "skipped_versions.txt"
        # Kill the app
        kill $APP_PID
        bash -c '/home/chaiman/dev/discord_updater/update_discord.sh'
        break
    done
}

check_output2() {
    # Use tail to follow the output of the temporary file and grep to filter the specific string
    tail -f "$TEMP_FILE" | while read -r line; do
        if [[ "$line" == *"update-manually"* ]]; then
            # Extract the version number using awk
            version_number=$(echo "$line" | awk '{print $NF}' | cut -d '.' -f 3)
            echo "[4dis] Discord signals about an update being available. Version number extracted: $version_number"
            # Store the version number in a variable
            VERSION_NUMBER=$version_number
            new_discord_version2=$((VERSION_NUMBER + 1))
            echo "[4dis] Patching the skipped versions list with: ${new_discord_version2}"
            echo $new_discord_version2 > "skipped_versions.txt"
            # Kill the app
            echo "[4dis] Killing the app"
            kill $APP_PID
            echo "[4dis] Removing the temp file"
            rm "$TEMP_FILE"
            echo "[4dis] Relaunching Discord updater script. It should update now on its own"
            bash -c '/home/chaiman/dev/discord_updater/update_discord.sh'
            break
        fi
    done
}

# Loop to continuously check the output
while true; do
    if check_output2; then
        echo "[4dis] String 'update-manually' found. Killing the app."
        break
    fi
    sleep 1  # Sleep for a short period to avoid high CPU usage
done

