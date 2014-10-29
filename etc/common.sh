pf_reload()
{
  sudo pfctl -nf /etc/pf.conf
  if [ $? -eq 0 ]; then
    sudo pfctl -f /etc/pf.conf
  fi
}

