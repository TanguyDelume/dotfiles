#!/usr/bin/env bash

. $(dirname $0)/lemonbar.config


if [ -e "${PANEL_FIFO}" ]; then 
    rm "${PANEL_FIFO}"
fi
mkfifo "${PANEL_FIFO}"

conky -c $(dirname $0)/lemonbar_conky > "${PANEL_FIFO}" &

cnt=0

work(){
    while true; do
        local ws=$(xprop -root _NET_CURRENT_DESKTOP | sed -e 's/_NET_CURRENT_DESKTOP(CARDINAL) = //' )
        local seq="%{F${color_back} B${color_sec_b1} T1} "
        local total=${DESKTOP_COUNT}
        
        for ((i=0;i<total;i++)); do
            if [[ "$i" -eq "$ws" ]]; then            
                seq="${seq}%{F${color_sec_b1} B${color_head} T3}${sep_right}%{F${color_back} B${color_head} T1}  %{F${color_head} B${color_sec_b1} T3}${sep_right}"
            else            
                seq="${seq}%{F- T1} • "
            fi
        done
        echo "WORKSPACES ${seq}%{F${color_sec_b1} B${color_back} T3}${sep_right}%{F- B- T1}"
        sleep ${WORKSPACE_SLEEP}
    done
}

work > "${PANEL_FIFO}" &

clock() 
{
    while true; do        
        local time="$(date +'%_I:%M%P')"
        # time        
        echo "CLOCK %{F${color_sel} B${color_sec_b1} T3}${sep_left}%{F${color_back} B${color_sel}} %{T2}${icon_clock} %{T1}${time} %{T1}%{F${color_head2} B${color_sel} T3}${sep_left}%{F- B- T1}"
        sleep ${TIME_SLEEP}
    done
}

clock > "${PANEL_FIFO}" &

datez() 
{
    while true; do
        local dates="$(date +'%a %d %b')"        
        echo "DATE %{F${color_sec_b1} B${color_sec_b1} T3}${sep_left}%{F${color_icon} B${color_sec_b1}} %{T2}${icon_date} %{F- T1}${dates}"
        sleep ${DATE_SLEEP}
    done
}

datez > "${PANEL_FIFO}" &

volume()
{
    cnt_vol=${upd_vol}

    while true; do
        local vol="$(amixer get Master | grep -E -o '[0-9]{1,3}?%' | head -1 | cut -d '%' -f1)"
        local mut="$(amixer get Master | grep -E -o 'off' | head -1)"

        if [[ ${mut} == "off" ]]; then
            echo "VOLUME %{F${color_yay} B${color_sec_b2} T3}${sep_left}%{F${color_back} B${color_yay}} %{T2}${icon_vol_mute} %{T1}MUTE %{F${color_sec_b1} B${color_yay} T3}${sep_left}%{F- B- T1} "
        elif (( vol == 0 )); then
            echo "VOLUME %{F${color_yay} B${color_sec_b2} T3}${sep_left}%{F${color_back} B${color_yay}} %{T2}${icon_vol_mute} %{T1}${vol}% %{F${color_sec_b1} B${color_yay} T3}${sep_left}%{F- B- T1} "
        elif (( vol > 70 )); then
            echo "VOLUME %{F${color_vol_alert} B${color_sec_b2} T3}${sep_left}%{F${color_back} B${color_vol_alert}} %{T2}${icon_vol} %{T1}${vol}% %{F${color_sec_b1} B${color_vol_alert} T3}${sep_left}%{F- B- T1} "
        elif (( vol > 55 )); then
            echo "VOLUME %{F${color_vol_warn} B${color_sec_b2} T3}${sep_left}%{F${color_back} B${color_vol_warn}} %{T2}${icon_vol} %{T1}${vol}% %{F${color_sec_b1} B${color_vol_warn} T3}${sep_left}%{F- B- T1} "
        elif (( vol > 10 )); then
            echo "VOLUME %{F${color_vol_good} B${color_sec_b2} T3}${sep_left}%{F${color_back} B${color_vol_good}} %{T2}${icon_vol} %{T1}${vol}% %{F${color_sec_b1} B${color_vol_good} T3}${sep_left}%{F- B- T1} "
        else
            echo "VOLUME %{F${color_sec_b2} B${color_sec_b2} T3}${sep_left}%{F${color_icon} B${color_sec_b2}} %{T2}${icon_vol}%{F- T1} ${vol}% %{F${color_sec_b1} B${color_sec_b2} T3}${sep_left}%{F- B- T1} "
        fi

        sleep ${VOLUME_SLEEP} 
    done
}

volume > "${PANEL_FIFO}" &


show_theme() {    
    while true; do
        
        echo "THEME %{A:~/.config/wall.sh:}%{F${color_head2} B${color_head2} T3}${sep_left}%{F- B${color_head2}} %{T2}${icon_theme} %{F${color_head2} B${color_head2} T3}${sep_left}%{F- B- T1}%{A}"

        sleep ${TIME_SLEEP}    
    done
    
}

show_theme > "${PANEL_FIFO}" &

while read -r line; do
    case $line in
        THEME*)
            fn_theme="${line#THEME }"
            ;;
        CLOCK*)
            fn_time="${line#CLOCK }"
            ;;
        DATE*)
            fn_date="${line#DATE }"
            ;;
        VOLUME*)
            fn_vol="${line#VOLUME }"
            ;;
        WORKSPACES*)
            fn_work="${line#WORKSPACES }"
            ;;       
        MEM*)
            fn_mem="%{F${color_sec_b2} T3}${sep_left}%{F${color_icon} B${color_sec_b2}} %{T2}${icon_mem}%{F- T1} ${line#MEM } "
            ;;
        CPU*)
            fn_cpu="%{F${color_sec_b2} T3}${sep_left}%{F${color_icon} B${color_sec_b2}} %{T2}${icon_cpu}%{F- T1} ${line#CPU } "
            ;;
        FREE*)
            fn_space="%{F${color_sec_b2} T3}${sep_left}%{F${color_icon} B${color_sec_b2}} %{T2}${icon_space}%{F- T1} ${line#FREE } "
            ;;
        WIN*)            
            num_title=$(xprop -id ${line#???} | awk '/_NET_WM_NAME/{$1=$2="";print}' | cut -d'"' -f2 | wc -c)

            if (( num_title > 30 )); then
                name="$(xprop -id ${line#???} | awk '/_NET_WM_NAME/{$1=$2="";print}' | cut -d'"' -f2 | head -1 | head -c 30)..."
            else
                name="$(xprop -id ${line#???} | awk '/_NET_WM_NAME/{$1=$2="";print}' | cut -d'"' -f2)"
            fi
            title="%{F${color_sec_b2} B${color_sec_b2} T3}${sep_right}%{F- B${color_sec_b2} T1} ${name} %{F${color_sec_b2} B- T3}${sep_right}%{F- B- T1} "
            ;;
    esac
    printf "%s\n" "%{l}${fn_work}${title}%{S1}${fn_work}${title} %{S0}%{r}${stab}${fn_space}${fn_mem}${fn_cpu}${fn_sync}${fn_vol}${fn_date}${stab}${fn_time}${fn_theme}%{S1}${fn_music}${fn_date}${stab}${fn_time}${fn_theme}"
done < "${PANEL_FIFO}" | lemonbar -d -f "${FONTS}" -f "${ICONFONTS}" -f "${FONTS_P}" -g "${GEOMETRY}" -B "${BBG}" -F "${BFG}" -u 2 | sh > /dev/null
