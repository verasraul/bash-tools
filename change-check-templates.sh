while read -r host; do
  find ~/github/icinga2-monorepo/ -type f -name "${host}*" | while read -r file; do
    # Skip if $file is empty or not a regular file
    if [[ -f "$file" ]]; then
      echo "Modifying: $file"
      sed -i 's/"utildmz-zookeeper"/"utildmz-zookeeper-no-logging-or-metrics"/g' "$file"
    fi
  done
done < ~/host.txt
