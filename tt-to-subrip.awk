#!/usr/bin/awk -f
BEGIN {
    # Use "<p> & </p>" to define a line
    RS="</?p>?";
    # i, the SubRip index
    i = 1;
}

# Parse the values to print the "timeline"
# Parameters: start and duration HH:MM:SS,MILLS (MILLS=3 digits), and
# if it is end time instad of duration
function time_line(start, duration, isEnd){
    # TODO Make it able to parse duration and start values like "30s"
    split(start,sta,"[:,]");
    split(duration,dur,"[:,.]")

    while(length(dur[4]) <3) {
      dur[4] = dur[4] "0"
    }
    if (isEnd) {
        for(item in dur)
            end[item] = dur[item];
    } else {
        end[4] = sta[4] + dur[4];
        end[3] = sta[3] + dur[3]+ int(ms/1000);
        end[2] = sta[2] + dur[2]+ int(sec/60);
        end[1] = sta[1] + dur[1] + int(min/60);
    }
    return sprintf("%s --> %02d:%02d:%02d,%03d\n",start,end[1],end[2]%60,end[3]%60,end[4]%1000);
}

# Loop through lines containing "begin"
/begin/{
    # Print index
    print i++;

    # Format and print the "timeline"
    start = gensub(/begin=|["]/,"","g",$1);
    start = gensub(/\./, ",", "g", start);
    duration = gensub(/>|dur|end|=|["]/, "", "g",$2);
    printf(time_line(start,duration,match($2,"end")));

    # Format and print the text
    sub(/^[^<>]+>/, "");
    gsub(/<\/?span[^<>]*>/,"");

    sub(/^( |\t|\s)+/, "");
    gsub(/<\/*p>*/, "");
    gsub("\r","");
    gsub(/ *\n */, "");
    gsub(/ *<br ?\/> */,"\n");
    gsub(/( |\t|\s)+$/, "");
    gsub(/\n( |\t|\s)+/, "\n");
    printf("%s\n\n", $0);
}

