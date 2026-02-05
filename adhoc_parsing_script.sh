
# Clean up previous result
#rm -f adhoc_results.txt

# Process the ad-hoc output and categorize
while read -r line; do
  host=$(echo "$line" | awk '{print $1}')
  
  if [[ "$line" =~ FAILED! ]]; then
    echo "FAILED      $host" >> adhoc_results.txt
  elif [[ "$line" =~ UNREACHABLE! ]]; then
    echo "UNREACHABLE $host" >> adhoc_results.txt
  elif [[ "$line" =~ SUCCESS ]]; then
    echo "CHANGED     $host" >> adhoc_results.txt
  fi
done < adhoc_output.log

