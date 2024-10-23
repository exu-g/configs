# save kde and plasma settings to gitprojects/configs
function kdesave
    rm -rf ./konsave-export-main ./konsave-export-main.knsv
    konsave --save konsave-export-main --force
    konsave --export-profile konsave-export-main
    unzip konsave-export-main.knsv -d konsave-export-main
    cp -r ./konsave-export-main/save/configs/* ~/gitprojects/configs/roles/config/files/.config/
    cp -r ./konsave-export-main/export/home_folder/.* ~/gitprojects/configs/roles/config/files/
    cp -r ./konsave-export-main/export/share_folder/* ~/gitprojects/configs/roles/config/files/.local/share/
    rm -rf ./konsave-export-main ./konsave-export-main.knsv
end
