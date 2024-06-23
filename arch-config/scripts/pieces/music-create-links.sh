#!/usr/bin/env bash
set -euo pipefail

# remove content of music directory
rm -rf "$HOME/Musik/"*

# change into music raw folder
pushd "$HOME/Nextcloud/MusikRaw"

# disable expansion of empty globs
shopt -s nullglob

for artdir in */; do
    # FIXME remove trailing slash
    artdir="${artdir%/}"
    # change into artist directory
    pushd "$artdir"

    for dir in */; do
        # FIXME remove trailing slash
        dir="${dir%/}"
        # change into directory
        pushd "$dir"

        for subdir in */; do
            if [ "$subdir" != "normalized/" ]; then
                # NOTE handle new paths with streaming services included
                # FIXME remove trailing slash
                subdir="${subdir%/}"
                # go into subdirectory
                pushd "$subdir"
                # create directory in music
                mkdir -p "$HOME/Musik/${artdir}/$subdir"

                # link cover image (jpg or png)
                if [ -f cover.jpg ]; then
                    ln -vf "$HOME/Nextcloud/MusikRaw/${artdir}/$dir/$subdir/cover.jpg" "$HOME/Musik/${artdir}/$subdir/"
                elif [ -f cover.png ]; then
                    ln -vf "$HOME/Nextcloud/MusikRaw/${artdir}/$dir/$subdir/cover.png" "$HOME/Musik/${artdir}/$subdir/"
                fi

                # make symbolic link to music
                # if the "normalized" directory exists, links are created
                if [ -d "normalized" ]; then
                    ln -svf "$HOME/Nextcloud/MusikRaw/${artdir}/$dir/$subdir/normalized/"* "$HOME/Musik/${artdir}/$subdir/"
                fi

                popd
            else
                # NOTE this stays the same, without streaming services included

                # create directory in music
                mkdir -p "$HOME/Musik/${artdir}/$dir"
                # link cover image (jpg or png)
                if [ -f cover.jpg ]; then
                    ln -vf "$HOME/Nextcloud/MusikRaw/${artdir}/$dir/cover.jpg" "$HOME/Musik/${artdir}/$dir/"
                elif [ -f cover.png ]; then
                    ln -vf "$HOME/Nextcloud/MusikRaw/${artdir}/$dir/cover.png" "$HOME/Musik/${artdir}/$dir/"
                fi

                # make symbolic link to music
                # if the "normalized" directory exists, links are created
                if [ -d "normalized" ]; then
                    ln -svf "$HOME/Nextcloud/MusikRaw/${artdir}/$dir/normalized/"* "$HOME/Musik/${artdir}/$dir/"
                fi
            fi
        done
        popd
    done
    popd
done
popd

echo Finished!

exit
