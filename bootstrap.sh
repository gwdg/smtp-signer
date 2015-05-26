#!/bin/sh
PERL_MODS="Crypt::SMIME Log::Log4perl Log::Dispatch::Syslog"
case `uname` in
  Darwin|OpenBSD)
    for m in ${PERL_MODS}; do
      sudo PERL_MM_USE_DEFAULT=1 perl -MCPAN -e"install $m"
    done
    ;;
  *)
    echo "FIXME: unsupported platform"
    ;;
esac

