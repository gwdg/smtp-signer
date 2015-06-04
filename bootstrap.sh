#!/bin/sh
case `uname` in
  Darwin)
    PERL_MODS="Crypt::SMIME Log::Log4perl Log::Dispatch::Syslog"
    for m in ${PERL_MODS}; do
      sudo PERL_MM_USE_DEFAULT=1 perl -MCPAN -e"install $m"
    done
    ;;
  OpenBSD)
    sudo pkg_add p5-Log-Log4perl-1.40 p5-Log-Dispatch-2.41p0
    curl -L https://cpanmin.us | perl - --sudo App::cpanminus
    PERL_MODS="Crypt::SMIME"
    for m in ${PERL_MODS}; do
      sudo cpanm --notest ${PERL_MODS}
    done
    ;;
  *)
    echo "FIXME: unsupported platform"
    ;;
esac

