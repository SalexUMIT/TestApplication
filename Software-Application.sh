#!/bin/bash

# Function to check for required tools and versions
check_requirements() {
    # Check if pandoc is installed and its version
    if ! command -v pandoc &> /dev/null
    then
        echo "Pandoc could not be found. Please install Pandoc."
        exit 1
    else
        PANDOC_VERSION=$(pandoc --version | head -n 1 | awk '{print $2}')
        REQUIRED_VERSION="1.12.3"
        if [ "$(printf '%s\n' "$REQUIRED_VERSION" "$PANDOC_VERSION" | sort -V | head -n1)" != "$REQUIRED_VERSION" ]; then
            echo "Pandoc version $PANDOC_VERSION is installed. Version 1.12.3 or higher is required."
            exit 1
        fi
    fi
}

# Function to process a single input file
process_file() {
    local INPUT_FILENAME=$1
    local VERBOSE=$2
    local PROJECT_ROOT=$(pwd)
    local INPUT_FILE="$PROJECT_ROOT/Data/$INPUT_FILENAME"
    local RMD_FILE="$PROJECT_ROOT/R_code/Test_reporting_final.Rmd"
    local OUTPUT_DIR="$PROJECT_ROOT/Test_report"
    
    # Check if the input file exists
    if [ ! -f "$INPUT_FILE" ]; then
        [ "$VERBOSE" == "true" ] && echo "Input file does not exist: $INPUT_FILE"
        return 1
    else
        [ "$VERBOSE" == "true" ] && echo "Input file exists: $INPUT_FILE"
    fi
    
    # Check if the RMarkdown file exists
    if [ ! -f "$RMD_FILE" ]; then
        [ "$VERBOSE" == "true" ] && echo "RMarkdown file does not exist: $RMD_FILE"
        return 1
    else
        [ "$VERBOSE" == "true" ] && echo "RMarkdown file exists: $RMD_FILE"
    fi
    
    # Create the output directory if it does not exist
    #mkdir -p "$OUTPUT_DIR"
    #[ "$VERBOSE" == "true" ] && echo "Output directory: $OUTPUT_DIR"
    
    # Construct the output file name
    local BASENAME=$(basename "$INPUT_FILE" .txt)
    local DATE=$(date +%Y-%m-%d)
    local OUTPUT_FILE="${OUTPUT_DIR}/Test_Protokoll_${BASENAME}.pdf"
 
    #[ "$VERBOSE" == "true" ] && echo "Output file will be: $OUTPUT_FILE"
    
    if [ -f "$OUTPUT_FILE" ]; then
        echo "Output file already exists: $OUTPUT_FILE"
        return 2
    fi
    
    # Run the RMarkdown render command with the input file as a parameter
    #[ "$VERBOSE" == "true" ] && echo "Running rmarkdown::render..."
    #Rscript -e "rmarkdown::render('$RMD_FILE', params=list(input_file='$INPUT_FILE'), output_file='$OUTPUT_FILE')"
    #Rscript -e "rmarkdown::render('R_code/Modul11_new.Rmd', params=list(input_file='$INPUT_FILENAME'), output_file=paste0('../Test_report/Test_Protokoll_', '$BASENAME','.pdf'))"
    # Run the RMarkdown render command with the input file as a parameter
    if [ "$VERBOSE" == "true" ]; then
        echo "Running rmarkdown::render..."
        Rscript -e "rmarkdown::render('R_code/Test_reporting_final.Rmd', params=list(input_file='$INPUT_FILENAME'), output_file=paste0('../Test_report/Test_Protokoll_', '$BASENAME','.pdf'))"
    else
        Rscript -e "rmarkdown::render('R_code/Test_reporting_final.Rmd', params=list(input_file='$INPUT_FILENAME'), output_file=paste0('../Test_report/Test_Protokoll_', '$BASENAME','.pdf'))" &> /dev/null
    fi
    
    # Check if the output file was created
    # if [ -f "$OUTPUT_FILE" ]; then
    #     [ "$VERBOSE" == "true" ] && echo "Report successfully created: /Test_report/Test_Protokoll_${BASENAME}.pdf"
    #     return 0
    # else
    #     [ "$VERBOSE" == "true" ] && echo "Report was not created. Please check for errors."
    #     return 1
    # fi
    
    #echo "Report created /Test_report/Test_Protokoll_${BASENAME}.pdf"
}

# Check requirements
check_requirements

# Initialize verbose mode to false
VERBOSE="false"

# Check if the --verbose flag is set
if [[ "$1" == "--verbose" ]]; then
    VERBOSE="true"
    shift # Remove --verbose from the arguments list
fi

# Loop to process multiple files
while true; do
    # Prompt the user for an input file
    echo "Please enter the input file name located in the Data folder, add true to enter into the test environent:"
    read INPUT_FILENAME VERBOSE
    
    # Prompt the user for an input file and verbose option
    #echo "Please enter the input file name located in the Data folder and verbose option (true/false), separated by a space:"
    #read INPUT_FILENAME VERBOSE
    
    # Set default for VERBOSE if not provided
    VERBOSE=${VERBOSE:-false}
    
    # Process the input file
    process_file "$INPUT_FILENAME" "$VERBOSE"
    RETVAL=$?
    
    #check if file already exists
    if [ $RETVAL -eq 2 ]; then
        echo "Output file already exists. Please provide a different input file."
        continue
    elif [ $RETVAL -ne 0 ]; then
        echo "There was an error processing the file."
        continue
    fi
    
    # Ask the user if they want to add another file or quit
    echo "Do you want to add another file? (y/n):"
    read ADD_ANOTHER
    
    if [ "$ADD_ANOTHER" != "y" ]; then
        break
    fi
done

# Pause to keep the window open
echo "Press any key to close..."
read -n 1 -s
