case `uname` in
  Darwin)
    mkdir -p _dl
    cd _dl
    F=packer_0.7.5_darwin_amd64.zip
    curl -JOL https://dl.bintray.com/mitchellh/packer/$F
    sudo unzip $F -d /usr/local/bin
    ;;
esac
