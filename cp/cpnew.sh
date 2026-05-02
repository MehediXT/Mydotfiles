#!/bin/bash

# cpnew.sh - Create new competitive programming file from template
# Usage: cpnew filename.cpp

if [ $# -eq 0 ]; then
    echo "Usage: cpnew <filename.cpp>"
    exit 1
fi

filename=$1

# Check if file already exists
if [ -f "$filename" ]; then
    echo "Error: File '$filename' already exists!"
    exit 1
fi

# Get the directory where this script is located
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
template_file="$script_dir/template.cpp"

# Check if template exists
if [ ! -f "$template_file" ]; then
    echo "Error: Template file not found at $template_file"
    exit 1
fi

# Copy template to new file
cp "$template_file" "$filename"

echo "✓ Created: $filename"
echo "✓ Opening in Neovim..."

# Open file in Neovim
nvim "$filename"
