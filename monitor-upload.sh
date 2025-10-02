if [ -z "$1" ] ; then
  echo "No timeout specified"
  echo "Using 120 seconds"
  seconds=120
else
  # Make sure is an integer greater or equal to 60
  if (( $1 >= 60 )); then
    seconds=$1
  else
    echo "Must specify 60 or more as the timeout parameter."
    echo "Syntax: $0 [timeout]"
    exit 1
  fi 2>/dev/null
fi

echo "Monitoring for $seconds seconds..."
brctl monitor -i -t $seconds com.apple.CloudDocs
