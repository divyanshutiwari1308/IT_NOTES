#!/bin/bash

# Display the options
echo "Choose an operation:"
echo "1. Zip a file or directory"
echo "2. Tar a file or directory"
echo "3. Unzip a .zip file"
echo "4. Untar a .tar, .tar.gz, or .tar.bz2 file"
echo "5. Exit"
read -p "Enter your choice (1/2/3/4/5): " choice

# Zip a file or directory
zip_file() {
    echo "Enter the file or directory you want to zip:"
    read file_or_dir
    echo "Enter the name of the output zip file (without extension):"
    read zip_name
    zip -r "$zip_name.zip" "$file_or_dir"
    echo "$file_or_dir has been zipped to $zip_name.zip"
}

# Tar a file or directory
tar_file() {
    echo "Enter the file or directory you want to tar:"
    read file_or_dir
    echo "Enter the name of the output tar file (without extension):"
    read tar_name
    echo "Choose a compression format: (1) gzip, (2) bzip2, (3) none"
    read compression_choice
    
    case $compression_choice in
        1) 
            tar -czvf "$tar_name.tar.gz" "$file_or_dir"
            echo "$file_or_dir has been tared and compressed to $tar_name.tar.gz"
            ;;
        2)
            tar -cjvf "$tar_name.tar.bz2" "$file_or_dir"
            echo "$file_or_dir has been tared and compressed to $tar_name.tar.bz2"
            ;;
        3)
            tar -cvf "$tar_name.tar" "$file_or_dir"
            echo "$file_or_dir has been tared to $tar_name.tar"
            ;;
        *)
            echo "Invalid choice! Exiting."
            exit 1
            ;;
    esac
}

# Unzip a .zip file
unzip_file() {
    echo "Enter the .zip file you want to unzip:"
    read zip_file
    unzip "$zip_file"
    echo "$zip_file has been unzipped."
}

# Untar a .tar, .tar.gz, or .tar.bz2 file
untar_file() {
    echo "Enter the tar file you want to untar (e.g., .tar, .tar.gz, .tar.bz2):"
    read tar_file
    case "$tar_file" in
        *.tar.gz)
            tar -xzvf "$tar_file"
            echo "$tar_file has been untarred."
            ;;
        *.tar.bz2)
            tar -xjvf "$tar_file"
            echo "$tar_file has been untarred."
            ;;
        *.tar)
            tar -xvf "$tar_file"
            echo "$tar_file has been untarred."
            ;;
        *)
            echo "Unsupported file format. Exiting."
            exit 1
            ;;
    esac
}

# Execute the appropriate function based on user's choice
case $choice in
    1) zip_file ;;
    2) tar_file ;;
    3) unzip_file ;;
    4) untar_file ;;
    5) echo "Exiting."; exit 0 ;;
    *)
        echo "Invalid choice! Exiting."
        exit 1
        ;;
esac
