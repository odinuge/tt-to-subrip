
# TimedText to SubRip
> Simple tt to srt converter, in awk.

![screenshot](screenshot.png)

## Overview

Converts subtitles in ttml (TimedText Markup Language) into subrip (srt) files.
Requires gawk.
 
## Install

```sh
$ git clone https://github.com/odinuge/tt-to-subrip/
```


## Usage

Use it like any other awk file.

```sh
$ curl -s "$URL" | gawk -f tt-to-subrip.awk > sub.srt
```

## FAQ

### X is not working.

Feel free to submit an issue or send a pull request.

## License

MIT © [Odin Ugedal](https://ugedal.com)
