# Normalize my music with ffmpeg and python

[Loudnorm Filter](https://ffmpeg.org/ffmpeg-filters.html#loudnorm)  

[Filtering Guide](https://trac.ffmpeg.org/wiki/FilteringGuide)  


[Two pass loudnorm](https://superuser.com/a/1312885)  
`ffmpeg -y -i FalKKonE\ -\ 01\ Aria\ \(From\ \"Berserk:\ The\ Golden\ Age\ Arc\"\).flac -pass 1 -filter:a loudnorm=print_format=json -f flac /dev/null`  

`ffmpeg -i FalKKonE\ -\ 01\ Aria\ \(From\ \"Berserk:\ The\ Golden\ Age\ Arc\"\).flac -pass 2 -filter:a loudnorm=I=-30.0:linear=true:measured_I=-4.52:measured_LRA=1.90:measured_thresh=-14.64 -c:a libopus -b:a 320k test441.opus`  


