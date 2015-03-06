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
    split(start,sta,"[:,]");
    split(duration,dur,"[:,.]")
    if (dur[4]+dur[3]*1000+dur[2]*60*1000+dur[1]*3600*1000 < 0 ) {
        dur[4] = 0;
        dur[3] = 0;
        dur[2] = 0;
        dur[1] = 0;
    }
    while(length(dur[4]) <3) {
      dur[4] = dur[4] "0"
    }
    ms = sta[4] + dur[4];
    sec = sta[3] + dur[3]+ int(ms/1000);
    min = sta[2] + dur[2]+ int(sec/60);
    hours = sta[1] + dur[1] + int(min/60);

    printf("%s --> %02d:%02d:%02d,%03d\n",start,hours,min%60,sec%60,ms%1000);
}

# Loop through lines containing "dur" (duration)
/dur/{
    # Print index
    print i++;

    # Format and print the "timeline"

    start = $1;
    duration = $2;
    gsub("dur=\"", "", duration);
    gsub("[=\"]", "", start);
    gsub("[=\"]", "", duration);
    gsub(/\./, ",", start);
    time_line(start,duration);

    # Format and print the text
    gsub("</span>","");
    gsub("<span style=\"italic\">", "");
    gsub("<br />","\n");
    sub("</p>.*", "");
    sub(".*>","");
    gsub("\r","");
    gsub("\n *","\n");
    sub(/^[ \t]+/, "");
    printf("%s\n\n", $0);
}

