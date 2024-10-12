# update config
function upconf
    cd (mktemp -d)
    git clone https://gitea.exu.li/exu/configs.git
    cd configs
    just config
end
