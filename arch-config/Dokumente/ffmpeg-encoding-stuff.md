# ffmpeg
- [List en-/decoders](https://write.corbpie.com/ffmpeg-list-all-codecs-encoders-decoders-and-formats/)
- [Map option to select video, audio, subtitle streams](https://trac.ffmpeg.org/wiki/Map)
- [ffmpeg doc](https://ffmpeg.org/ffmpeg.html)
- [H.265 encoding](https://trac.ffmpeg.org/wiki/Encode/H.265)
- [change metadata](https://stackoverflow.com/questions/26666879/ffmpeg-video-metadata-change)
- [H.264 tunes](https://trac.ffmpeg.org/wiki/Encode/H.264#crf)
- [Hardware acceleration](https://trac.ffmpeg.org/wiki/HWAccelIntro)
- [VAAPI](https://trac.ffmpeg.org/wiki/Hardware/VAAPI)
- [Set stream as default](https://stackoverflow.com/questions/26956762/ffmpeg-set-subtitles-track-as-default)

## Tests
- Keijo!!!!!!!! - S01E01 handbrake h264  
- size: 607.4MB  

- Keijo!!!!!!!! - S01E01 hevc_vaapi -qp 20  
- size: 957.7MB  
`ffmpeg -vaapi_device /dev/dri/renderD128 -i \[EXP\]\ Keijo!!!!!!!!\ -\ S01E01\ \[BDRip\ 1920x1080\ HEVC\ FLAC\]\ \[76BC6060\].mkv -c:v hevc_vaapi -c:a libopus -b:a 192k -qp 20 -vf 'format=nv12,hwupload' "Keijo!!!!!!!! - S01E01 -qp 20.mkv`  

- Keijo!!!!!!!! - S01E01 hevc_vaapi -crf 20  
- size: 534.3MB  
`ffmpeg -vaapi_device /dev/dri/renderD128 -i \[EXP\]\ Keijo!!!!!!!!\ -\ S01E01\ \[BDRip\ 1920x1080\ HEVC\ FLAC\]\ \[76BC6060\].mkv -c:v hevc_vaapi -c:a libopus -b:a 192k -crf 20 -vf 'format=nv12,hwupload' "Keijo!!!!!!!! - S01E01 -crf 20.mkv"`  

- Keijo!!!!!!!! - S01E01 hevc_vaapi -crf 20 -tune animation  
- size: 534.3MB  
`ffmpeg -vaapi_device /dev/dri/renderD128 -i \[EXP\]\ Keijo!!!!!!!!\ -\ S01E01\ \[BDRip\ 1920x1080\ HEVC\ FLAC\]\ \[76BC6060\].mkv -c:v hevc_vaapi -c:a libopus -b:a 192k -crf 20 -vf 'format=nv12,hwupload' -tune animation "Keijo!!!!!!!! - S01E01 -crf 20.mkv"`  

- Keijo!!!!!!!! - S01E01 h264_vaapi -crf 20 -tune animation  
- size: 1GB  
`ffmpeg -vaapi_device /dev/dri/renderD128 -i \[EXP\]\ Keijo!!!!!!!!\ -\ S01E01\ \[BDRip\ 1920x1080\ HEVC\ FLAC\]\ \[76BC6060\].mkv -c:v h264_vaapi -c:a libopus -b:a 192k -crf 20 -vf 'format=nv12,hwupload' -tune animation "Keijo!!!!!!!! - S01E01 vaapi h264 -crf 20 -tune animation.mkv"`  

- Keijo!!!!!!!! - S01E01 hevc_vaapi -crf 20 -tune animation metadata  
- with metadata on tracks
- size: 534.3MB  
`ffmpeg -vaapi_device /dev/dri/renderD128 -i \[EXP\]\ Keijo!!!!!!!!\ -\ S01E01\ \[BDRip\ 1920x1080\ HEVC\ FLAC\]\ \[76BC6060\].mkv -c:v hevc_vaapi -c:a libopus -b:a 192k -crf 20 -vf 'format=nv12,hwupload' -tune animation -metadata:s:v:0 title="Video" -metadata:s:a:0 title="Japanese" -metadata:s:a:0 language=jpn -metadata:s:s:0 title="English" -metadata:s:s:0 language=eng "Keijo!!!!!!!! - S01E01 -crf 20.mkv"`

- Keijo!!!!!!!! - S01E01 libx264 -crf 20 -tune animation metadata  
- with metadata on tracks  
- size: 530.7MB  
`ffmpeg -i \[EXP\]\ Keijo!!!!!!!!\ -\ S01E01\ \[BDRip\ 1920x1080\ HEVC\ FLAC\]\ \[76BC6060\].mkv -c:v libx264 -c:a libopus -b:a 192k -crf 20 -tune animation -metadata:s:v:0 title="Video" -metadata:s:a:0 title="Japanese" -metadata:s:a:0 language=jpn -metadata:s:s:0 title="English" -metadata:s:s:0 language=eng "Keijo!!!!!!!! - S01E01 -crf 20.mkv"`  

- Death Note - 01 - Rebirth libx264 mapped metadata tune  
- Example with mapping streams and setting default stream  
    - one video stream
    - two audio streams, japanese and english
    - two subtitle streams, only using the full subtitles
- size:   
`ffmpeg -i \[Arid\]\ Death\ Note\ -\ 01\ -\ Rebirth\ \[3BECAA78\].mkv -c:v libx264 -c:a libopus -b:a 192k -crf 20 -tune animation -map 0:v:0 -map 0:a:0 -map 0:a:1 -map 0:s:0 -metadata:s:v:0 title="Video" -metadata:s:a:0 title="Japanese" -metadata:s:a:0 language=jpn -disposition:a:0 default -metadata:s:a:1 title="English" -metadata:s:a:1 language=eng -metadata:s:s:0 title="English" -metadata:s:s:0 language=eng -disposition:s:0 default "Death Note - 01 - Rebirth libx264 mapped metadata tune.mkv"`  

Convert Season in loop  
```
for i in (seq -w 1 26)

ffmpeg -i \[Judas\]\ Kimetsu\ no\ Yaiba\ -\ S01E{$i}.mkv -c:v libx264 -c:a libopus -b:a 192k -crf 20 -tune animation -c:s copy -map 0:v:0 -map 0:a:0 -map 0:a:1 -map 0:s:0 -metadata:s:v:0 title="Video" -metadata:s:a:0 title="Japanese" -metadata:s:a:0 language=jpn -disposition:a:0 default -metadata:s:a:1 title="English" -metadata:s:a:1 language=eng -metadata:s:s:0 title="English" -metadata:s:s:0 language=eng -disposition:s:0 default "/mnt/storage/MediaLibrary/Handbrake-output/Demon Slayer/Demon Slayer - Kimetsu no Yaiba - S01E$i.mkv"

end
```

Death Note bluray  
```
for i in (seq -w 2 37)

ffmpeg -i Death\ Note\ -\ S01E{$i}.mkv -c:v libx264 -c:a libopus -b:a 192k -crf 20 -tune animation -c:s copy -map 0:v:0 -map 0:a:0 -map 0:a:1 -map 0:s:0 -metadata title="Death Note - S01E$i" -metadata:s:v:0 title="Video" -metadata:s:a:0 title="English" -metadata:s:a:0 language=eng -metadata:s:a:1 title="Japanese" -metadata:s:a:1 language=jpn -disposition:a:1 default -metadata:s:s:0 title="English" -metadata:s:s:0 language=eng -disposition:s:0 default "Death Note - S01E$i [1080p].mkv"

end
```

Complex example with different audio channels  
Note that the disposition is deleted first. Otherwise later settings might not apply  
```
for i in (seq -w 1 25); ffmpeg -i Steins\;Gate\ -\ {$i}.mkv -metadata title="Steins;Gate - $i" -map_metadata -1 -disposition 0 \

-c:v libx264 -crf 20 -tune animation -map 0:v:0 -metadata:s:v:0 title="Video" \

-c:a libopus -b:a:0 576k -b:a:1 192k -ac:a:0 6 -ac:a:1 2 -map 0:a:0 -map 0:a:1 -metadata:s:a:0 title="English" -metadata:s:a:0 language=eng -metadata:s:a:1 title="Japanese" -metadata:s:a:1 language=jpn -disposition:a:1 default \
                                                                                                    -c:s copy -map 0:s:3 -metadata:s:s:3 title="English" -metadata:s:s:3 language=eng -disposition:s:3 default \
                                                                                                    "/mnt/storage/MediaLibrary/Handbrake-output/Steins;Gate/Steins;Gate - $i [1080p].mkv"; end
```

Note how the subtitles are identified by their new id after mapping  
```
for i in (seq -w 1 13); ffmpeg -i Vivy\ -\ Flourite\ Eye\'s\ Song\ -\ {$i}.mkv -metadata title="Vivy - Flourite Eye's Song - $i" -map_metadata -1 -disposition 0 \

-c:v libx264 -crf 20 -tune animation -map 0:v:0 -metadata:s:v:0 title="Video" \

-c:a libopus -b:a 192k -map 0:a:0 -map 0:a:1 -metadata:s:a:0 title="English" -metadata:s:a:0 language=eng -metadata:s:a:1 title="Japanese" -metadata:s:a:1 language=jpn -disposition:a:1 default \

-c:s copy -map 0:s:1 -metadata:s:s:0 title="English" -metadata:s:s:0 language=eng -disposition:s:0 default \

/mnt/storage/MediaLibrary/output/Vivy\ -\ Flourite\ Eye\'s\ Song/Vivy\ -\ Flourite\ Eye\'s\ Song\ -\ {$i}.mkv; end
```

Include subtitles from external files  
```
for i in (seq -w 1 11); ffmpeg -i Bartender\ {$i}\ \[BDRip\ 1920x1080\ HEVC\ FLAC\].mkv -i ENG\ Subs/Bartender\ {$i}\ \[BDRip\ 1920x1080\ HEVC\ FLAC\].eng.\[BD\].sup.mks -metadata title="Bartender - S01E$i" -map_metadata -1 -disposition 0 \

-c:v libx264 -crf 20 -tune animation -map 0:v:0 -metadata:s:v:0 title="Video" \
                                       
-c:a libopus -b:a 192k -map 0:a:0 -metadata:s:a:0 title="Japanese" -metadata:s:a:0 language=jpn \

-c:s copy -map 1:s:0 -metadata:s:s:0 title="English" -metadata:s:s:0 language=eng \

/mnt/storage/MediaLibrary/output/Bartender/Bartender\ \-\ S01E{$i}\ \[1080p\].mkv; end
```
