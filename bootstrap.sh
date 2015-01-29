#!/bin/sh
PERL_MODS="Crypt::SMIME Log::Log4perl"
case `uname` in
  Darwin)
    for m in ${PERL_MODS}; do
      sudo perl -MCPAN -e"install $m"
    done
    ;;
  *)
    echo "FIXME: unsupported platform"
    ;;
esac

