let battery-capacity = (open /sys/class/power_supply/BAT0/capacity | str trim)
let time = (date now | date format '%_I:%M')

echo [ $battery-capacity '% | ' $time ] | str collect
