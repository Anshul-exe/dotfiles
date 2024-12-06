#!/bin/bash

# author: Nikhil Singh
# email:  nik.singh710@gmail.com
# tg:     https://t.me/niksingh710
# github: https://github.com/niksingh710

# Function to display usage information
usage() {
  echo "Usage: $0 --url <URL> --pdf-viewer <PDF_VIEWER>"
  echo "Example: $0 --url https://example.com --pdf-viewer zathura"
  exit 1
}

# Initialize variables
URL="https://mygbu.in/schd/?name=SOICT&dept=CSE&section=31"
PDF_VIEWER="zathura"

# Parse command-line arguments
while [[ $# -gt 0 ]]; do
  case "$1" in
  --url)
    URL="$2"
    shift 2
    ;;
  --pdf-viewer)
    PDF_VIEWER="$2"
    shift 2
    ;;
  *)
    usage
    ;;
  esac
done

# Validate input
if [[ -z "$URL" || -z "$PDF_VIEWER" ]]; then
  usage
fi

check() {
  command -v "$1" &>/dev/null
}

# Check if required commands are installed
if ! check "wkhtmltopdf" || ! check "$PDF_VIEWER"; then
  echo "Required commands not found. Please install them."
  echo "wkhtmltopdf: https://wkhtmltopdf.org/"
  echo "PDF_VIEWER: $PDF_VIEWER"
  exit 1
fi

# Generate PDF
PDF_FILE="/tmp/gbu-tt.pdf"
echo ".navbar { display: none; }" >/tmp/gbu-remove.css

wkhtmltopdf --user-style-sheet "/tmp/gbu-remove.css" --page-size A4 --orientation Landscape "$URL" "$PDF_FILE" &>/dev/null
echo "PDF should be getting displayed in $PDF_VIEWER"
echo "🍻 Nikhil Singh ~ https://github.com/niksingh710"
$PDF_VIEWER "$PDF_FILE" &>/dev/null
