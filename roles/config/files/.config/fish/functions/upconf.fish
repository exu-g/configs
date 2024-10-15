# update config
function upconf
    pushd (mktemp -d)
    git clone https://gitea.exu.li/exu/configs.git
    cd configs
    just config
    popd
end
