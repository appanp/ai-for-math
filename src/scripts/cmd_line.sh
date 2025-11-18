# Command to list files which do not appear in README.md
while IFS= read -r ip_file; do
  tmp_str=${ip_file##*/}
  u_sfx=${tmp_str%.pdf}
  ripgrep "$u_sfx" README.md
  if [ $? -ne 0 ]; then
    echo "File not found: $ip_file"
  fi
done < <(ls papers/*.pdf)

# Command to list the missing pdf files
while IFS= read -r ip_line; do
  tmp_str="${ip_line#[}"
  p_t="${tmp_str%](*}"
  p_url="${tmp_str#*](}"
  f_nme="${p_url##*/}"
  if [[ ! -f papers/${f_nme}.pdf ]]; then
    echo "Paper: $p_t : $p_url"
  fi
done < <(ripgrep -N -o '\[([^\]]+)\]\(https://(arxiv|publik)[^\)]+' README.md)
