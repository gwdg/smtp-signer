#!/bin/sh
PERL_MODS="Crypt::SMIME Log::Log4perl Log::Dispatch::Syslog"
case `uname` in
  Darwin)
    for m in ${PERL_MODS}; do
      sudo perl -MCPAN -e"install $m"
    done
    ;;
  OpenBSD)
    pkg_add postfix-2.12.20140109
    ;;
  *)
    echo "FIXME: unsupported platform"
    ;;
esac

