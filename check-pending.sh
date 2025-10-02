echo "Checking Status for Pending Uploads."
echo "Please wait..."

# Store result in a variable
pending=$(brctl status | grep "needs-upload")

# Use Variable to count lines
cnt=$(printf "%s" "$pending" | wc -l)

# if $pending is not empty count the last linei
# (which doesn't has a newline character)
if [ -n "$pending" ]; then
  cnt=$((cnt+1))
else
  # Remove leading spaces
  cnt=$(echo "$cnt" | awk '{$1=$1; print}')
fi

# Show pending files (unless --quiet option was provided)
if [[ "$1" != "--quiet" ]] ; then
  [ -n "$pending" ] && echo "$pending" 
fi

echo
echo "----"
echo "$cnt files pending upload..."
echo "----"
echo
