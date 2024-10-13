#!/bin/bash

# Get the current date in PST
START_DATE=$(TZ='America/Los_Angeles' date +%Y-%m-%d)

# Create the commit_and_push.sh script
cat << 'EOF' > commit_and_push.sh
#!/bin/bash

START_DATE="$START_DATE"

# Check if a commit message was provided
if [ $# -eq 0 ]; then
    echo "Error: No commit message provided."
    echo "Usage: $0 <commit message>"
    exit 1
fi

# Combine all arguments into a single commit message
commit_message="$*"

git add .

# Calculate days since start (in PST)
days_since_start=$(TZ='America/Los_Angeles' \
    expr $(date +%s) - $(date -d "$START_DATE" +%s) )
days_since_start=$(( days_since_start / 86400 ))

# Function to get correct ordinal suffix
ordinal_suffix() {
    case $(($1 % 100)) in
        11|12|13) echo "th";;
        *) case $(($1 % 10)) in
            1) echo "st";;
            2) echo "nd";;
            3) echo "rd";;
            *) echo "th";;
        esac
    esac
}

# Get current date and time in PST
current_datetime=$(TZ='America/Los_Angeles' date '+%Y-%m-%d %H:%M:%S %Z')

# Commit and push
git commit -m "${days_since_start}$(ordinal_suffix $days_since_start) day: $commit_message (PST: $current_datetime)"
git push
EOF

# Make the generated script executable
chmod +x commit_and_push.sh

echo "Bash script generated: commit_and_push.sh (using PST, accepts commit message as argument)"
