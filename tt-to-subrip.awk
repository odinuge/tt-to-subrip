#!/usr/bin/awk -f
BEGIN {
    # Use "<p> & </p>" to define a line
    RS="</?p>?";
    # i, the SubRip index
    i = 1;
}

# Parse the values to print the "timeline"
# Parameters: start and duration HH:MM:SS,MILLS (MILLS=3 digits)
function time_line(start, duration){
    # TODO Make it able to parse duration and start values like "30s"
    split(start,sta,"[:,]");
    split(duration,dur,"[:,.]")

    while(length(dur[4]) <3) {
      dur[4] = dur[4] "0"
    }
    ms = sta[4] + dur[4];
    sec = sta[3] + dur[3]+ int(ms/1000);
    min = sta[2] + dur[2]+ int(sec/60);
    hours = sta[1] + dur[1] + int(min/60);

    return sprintf("%s --> %02d:%02d:%02d,%03d\n",start,hours,min%60,sec%60,ms%1000);
}

# Loop through lines containing "begin"
/begin/{
    # Print index
    print i++;

    # Format and print the "timeline"
    start = gensub(/begin=|["]/,"","g",$1);
    start = gensub(/\./, ",", "g", start);
    duration = gensub(/>|dur|=|["]/, "", "g",$2);
    printf(time_line(start,duration));

    # Format and print the text
    sub(/^[^<>]+>/, "");
    sub(/^ +/, "");
    gsub(/<\/?span[^<>]*>/,"");
    gsub(/<\/*p>*/, "");
    gsub("\r","");
    gsub(/ *\n */, "");
    gsub(/ *<br ?\/> */,"\n");
    sub(/ +$/, "");
    printf("%s\n\n", $0);
}

