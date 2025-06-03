cpu=$(top -bn2 -d0.01 | rg Cpu | tail -n1 | awk '{print 100-$8 "%"}')

ram=$(free --mebi | awk '/Mem/ {print $3 " / " $2}')

if [[ $(pactl get-sink-mute \@DEFAULT_SINK@ | awk '/yes/ {print}') ]]; then
    volume="Muted"
else
    volume=$(pactl get-sink-volume \@DEFAULT_SINK@ | awk '/Volume/ {print $5}')
fi

date_and_time=$(date +'%A, %d %B %Y | %H:%M')

echo "CPU: $cpu | RAM (MiB): $ram | Volume: $volume | $date_and_time |"
