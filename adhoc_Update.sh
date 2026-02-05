#!/bin/bash

# Set variables
INVENTORY=~/workspace/inv.ini
USER=raul.veras
MODULE=shell
COMMAND="sudo yum makecache && sudo yum -y update monitoring-plugins-dss"
LOG_FILE="adhoc_output.log"
RESULT_FILE="adhoc_results.txt"

# Run ad-hoc command and save output
echo "Running Ansible ad-hoc command..."
ansible all \
  -i "$INVENTORY" \
  -m "$MODULE" \
  -a "$COMMAND" \
  -u "$USER" -k -K \
  | tee -a "$LOG_FILE"

# Remove previous results
#rm -f "$RESULT_FILE"

# Parse output
echo "Parsing results..."
while read -r line; do
  host=$(echo "$line" | awk '{print $1}')

  if [[ "$line" =~ FAILED! ]]; then
    echo "FAILED      $host" >> "$RESULT_FILE"
  elif [[ "$line" =~ UNREACHABLE! ]]; then
    echo "UNREACHABLE $host" >> "$RESULT_FILE"
  elif [[ "$line" =~ CHANGED ]]; then
    echo "CHANGED     $host" >> "$RESULT_FILE"
  fi
done < "$LOG_FILE"

echo "Done. Results saved to: $RESULT_FILE"

