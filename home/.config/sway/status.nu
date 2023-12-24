let battery_capacity = (open /sys/class/power_supply/BAT0/capacity | str trim)
let time = (date now | format date '%_I:%M')

echo [ $battery_capacity '% | ' $time ] | str join
