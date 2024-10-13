# save kde and plasma settings to gitprojects/configs
function kdesave
    rm -rf ~/.config/konsave
    rm -rf ./konsave-export-main ./konsave-export-main.knsv
    ~/gitprojects/konsave/venv/bin/python -m konsave --save konsave-export-main --force
    ~/gitprojects/konsave/venv/bin/python -m konsave --export-profile konsave-export-main
    unzip konsave-export-main.knsv -d konsave-export-main
    cp -r ./konsave-export-main/save/configs/* ~/gitprojects/configs/roles/config/files/.config/
    cp -r ./konsave-export-main/export/home_folder/.* ~/gitprojects/configs/roles/config/files/
    cp -r ./konsave-export-main/export/share_folder/* ~/gitprojects/configs/roles/config/files/.local/share/
    rm -rf ./konsave-export-main ./konsave-export-main.knsv
end
