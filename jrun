#!/bin/bash

# Check if a filename was provided
if [[ $# -ne 1 ]]; then
    echo "Usage: jrun <JavaFileName.java>"
    exit 1
fi

SOURCE_FILE="$1"

# Check if the source file exists
if [[ ! -f "$SOURCE_FILE" ]]; then
    echo "Error: $SOURCE_FILE not found!"
    exit 1
fi

# Compile the Java program
javac "$SOURCE_FILE"

# Get the name of the main class (without the .java extension)
CLASS_NAME="${SOURCE_FILE%.java}"

# Check if the compilation was successful
if [[ $? -eq 0 ]]; then
    # Run the Java program
    java "$CLASS_NAME"
else
    echo "Compilation failed."
    exit 1
fi

