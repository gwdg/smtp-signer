case `uname` in
  Darwin)
    mkdir -p _dl
    cd _dl

    curl -JOL https://dl.bintray.com/mitchellh/vagrant/vagrant_1.7.2.dmg
    hdiutil attach vagrant_1.7.2.dmg
    sudo installer -pkg /Volumes/Vagrant/Vagrant.pkg -target LocalSystem
    hdiutil detach /Volumes/Vagrant

    curl -JOL http://download.virtualbox.org/virtualbox/4.3.26/VirtualBox-4.3.26-98988-OSX.dmg
    hdiutil attach VirtualBox-4.3.26-98988-OSX.dmg
    sudo installer -pkg /Volumes/VirtualBox/VirtualBox.pkg -target LocalSystem
    hdiutil detach /Volumes/VirtualBox

    sudo cat <<EOF >>/etc/sudoers
Cmnd_Alias VAGRANT_EXPORTS_ADD = /usr/bin/tee -a /etc/exports
Cmnd_Alias VAGRANT_NFSD = /sbin/nfsd restart
Cmnd_Alias VAGRANT_EXPORTS_REMOVE = /usr/bin/sed -E -e /*/ d -ibak /etc/exports
%admin ALL=(root) NOPASSWD: VAGRANT_EXPORTS_ADD, VAGRANT_NFSD, VAGRANT_EXPORTS_REMOVE
EOF
    ;;
esac

git clone https://github.com/gwdg/smtp-signer.git

