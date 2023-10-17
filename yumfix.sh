# Input Vulns
input(){
    input_file="input.txt"

    # Check if the file exists
    if [ ! -f "$input_file" ]; then
        echo "Error: $input_file not found."
        exit 1
    fi

    # Read lines from the file and store them in an array
    lines=()
    while IFS= read -r line; do
        lines+=("$line")
    done < "$input_file"
}

# VA Fix
vafix(){
    # Print the array elements
    for pkg in "${lines[@]}"; do
    # Run yum update command and capture stderr into error_message variable
    error_message=$(sudo yum update $pkg -y 2>&1)
    
    # Check if the error message contains "No Match for argument"
    if [[ $error_message == *"but not installed"* ]]; then
        # Log the error message to install file
        echo "Installing $pkg..."
        sudo yum install $pkg -y >/dev/null 2>&1
        echo "Installed : $pkg"
        echo $pkg >> done.txt
    elif [[ $error_message == *"No match for argument"* || $error_message == *"No Match for argument"* ]]; then
        # Log the error message to error file.
        echo "$pkg" >> error.txt
        echo "Failed : $pkg"
    else 
        # Package was updated successfully
        echo "Updating $pkg..."
        sudo yum update $pkg -y >/dev/null 2>&1
        echo $pkg >> done.txt
        echo "Updated : $pkg"
    fi
done
}

input
vafix

