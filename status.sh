cpu=$(uptime | awk -F ',' '{print $3}' | awk '{print $3}')

ram=$(free --mebi | awk '/Mem/ {print $3 "/" $2}')

if [[ $(pactl get-sink-mute \@DEFAULT_SINK@ | awk '/yes/ {print}') ]]; then
    volume="Muted"
else
    volume=$(pactl get-sink-volume \@DEFAULT_SINK@ | awk '/Volume/ {print $5}')
fi

date=$(date +'%A %d/%m/%Y %X')

echo "CPU: $cpu/$(nproc) | RAM: $ram | Volume: $volume | $date |"
