#ref : https://c10106.tistory.com/5133
#ref : https://github.com/fearside/ProgressBar/blob/master/progressbar.sh
#ref : http://fitnr.com/showing-a-bash-spinner.html
#ref : https://www.youtube.com/watch?v=93i8txD0H3Q
#!/bin/sh

function hide_cursor() {
    echo -n `tput civis`
}

function show_cursor() {
    echo -n `tput cvvis`
}

function progress () {
    # Display a progress bar
    # usage: progress percentage
    #
    # PERCENTAGE should be in range between 0 and 100.
    # If PERCENTAGE is 100, this function returns 1, otherwise returns zero.
    echo -en "\r["

    inc=$1
    if test $inc -gt 100; then          # 더 큼 >
        inc=100;
    fi

    num=`expr 40 \* "$inc" / 100`
    i=0
    while test $i -le $num; do
        echo -n "="
        i=`expr $i + 1`
    done

    while test $i -le 40; do
        echo -n " "
        i=`expr $i + 1`
    done

    echo -n "] $inc%"

    if test $inc -ge 100; then
        return 1
    else
        return 0
    fi
}


incr=0
hide_cursor
trap 'show_cursor; echo ""; exit 1' INT QUIT TERM EXIT

while progress $incr; do
    incr=`expr $incr + 10`
    sleep 1
done

echo ""
show_cursor
