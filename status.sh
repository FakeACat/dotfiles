cpu=$(top -bn2 -d0.01 | rg Cpu | tail -n1 | awk '{print 100-$8 "%"}')

ram=$(free --mebi | awk '/Mem/ {print $3 "Mi / " $2 "Mi"}')

if [[ $(pactl get-sink-mute \@DEFAULT_SINK@ | awk '/yes/ {print}') ]]; then
    volume="Muted"
else
    volume=$(pactl get-sink-volume \@DEFAULT_SINK@ | awk '/Volume/ {print $5}')
fi

date=$(date +'%A %d/%m/%Y %X')

echo "CPU: $cpu | RAM: $ram | Volume: $volume | $date |"
