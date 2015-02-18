#!/usr/bin/awk -f
BEGIN {
    # Use "begin" to define a line
    RS="begin";
    # i it the SubRip index
    i = 1;
}

# Parse the values to print the "timeline"
# Parameters: start and duration HH:MM:SS,MILLS (MILLS=3 digits)
function time_line(start, duration){
    # TODO Make able to parse duation and start values like "30s"
    gsub("[>]","",duration);
    ms = (substr(start,10,3) + substr(duration,10,3));
    sec = substr(start,7,2) + substr(duration,7,2) + int(ms/1000);
    min = substr(start,4,2) + substr(duration,4,2) + int(sec/60);
    hours = substr(start,1,2) + substr(duration,1,2) + int(min/60);

    printf("%s --> %02d:%02d:%02d,%03d\n",start,hours,min%60,sec%60,ms%1000);
}

# Loop through lines containing "dur" (duration)
/dur/{
    # Print index
    print i++;

    # Format and print the "timeline"
    gsub("[=\"]", "", $1);
    gsub(/\./, ",", $1);
    gsub("[dur=\"]", "", $2);
    time_line($1,$2);

    # Format and print the text
    gsub("<br />","\n");
    sub("</p>.*", "");
    gsub(/<span style="[italic,bold,underline]">/, "");
    gsub("</span>",""); 
    sub(".*>","");
    gsub("\r","");
    printf("%s\n\n", $0);
}

