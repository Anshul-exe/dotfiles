#!/bin/bash

ROFI_THEME="$HOME/.config/rofi/topRight.rasi"

# Format:
entries=(
  "Name|Anshul Singh Chauhan"
  "University|Gautam Buddha University"
  "Summary|I'm a DevOps Engineer with strong Linux, networking, AWS, Kubernetes, Docker, Terraform, and CI/CD expertise. Built secure cloud-native platforms with DevSecOps, GitOps, Infrastructure as Code, automated security-gated deployments, reduced manual effort by 95% and CVE from 12 to 0. Experienced in EKS, containerized microservices, high-availability 3-tier architectures, observability, and FinOps driven cloud cost optimization."
  "Degree|B.Tech CSE with specialization in AI)"
  "Internship|Digital Automation Cell - Gautam Buddha University"
  "LinkedIn|https://www.linkedin.com/in/anshulsinghchauhan/"
  "GitHub|https://github.com/Anshul-exe"
  "Role|DevOps Engineer"
  "Number|+919264920017"
  "Location|Greater Noida, Uttar Pradesh, India"
  "Cloud Guardian|https://github.com/Anshul-exe/Autonomous-Cloud-Guardian"
  "3 Tier Lab|https://github.com/Anshul-exe/3Tier-End-to-End-Prod-Infra"
  "Phone|9264920017"
  "Mail|anshulchauhan1224@gmail.com"
)

# Clipboard setter
set_clipboard() {
  local content="$1"

  if command -v xclip >/dev/null 2>&1; then
    printf "%s" "$content" | xclip -selection clipboard
  elif command -v xsel >/dev/null 2>&1; then
    printf "%s" "$content" | xsel --clipboard --input
  elif command -v wl-copy >/dev/null 2>&1; then
    printf "%s" "$content" | wl-copy
  else
    echo "No clipboard utility found"
    exit 1
  fi
}

# Generate menu
options=""
for entry in "${entries[@]}"; do
  name="${entry%%|*}"
  options+="$name\n"
done

# Case-insensitive matching enabled
selected=$(echo -e "$options" |
  rofi -dmenu \
    -i \
    -p "Quick Insert" \
    -theme "$ROFI_THEME")

[[ -z "$selected" ]] && exit 0

# Find selected item (case-insensitive)
for entry in "${entries[@]}"; do
  name="${entry%%|*}"
  value="${entry#*|}"

  if [[ "${selected,,}" == "${name,,}" ]]; then
    set_clipboard "$value"
    notify-send "Copied" "$value copied to clipboard"
    exit 0
  fi
done
