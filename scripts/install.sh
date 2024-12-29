#!/bin/bash

echo "Installing git, base-devel and yay..."

sudo pacman -S --needed git base-devel 
git clone https://aur.archlinux.org/yay-bin.git 
cd yay-bin 
makepkg -si

cd ..

if [ ! -f "packages.txt" ]; then
  echo "Error: packages.txt not found!"
  exit 1
fi

yay -S --needed - < packages.txt

if [ $? -eq 0 ]; then
  echo "Packages installed successfully."
else
  echo "Error during installation!"
fi


echo "Copying configs..."

SOURCE_DIR="$(dirname "$PWD")/.config"
DEST_DIR="$HOME/.config"

if [ ! -d "$SOURCE_DIR" ]; then
  echo "Error: Source directory $SOURCE_DIR does not exist!"
  exit 1
fi

cp -r "$SOURCE_DIR"/* "$DEST_DIR"

if [ $? -eq 0 ]; then
  echo "Folders copied successfully to $DEST_DIR."
else
  echo "Error occurred while copying folders."
fi

echo "Downloading fonts..."

DOWNLOAD_URL = "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.3.0/JetBrainsMono.zip"
DEST_FILE = "JetBrainsMono.zip"

wget "$DOWNLOAD_URL" -O "$DEST_FILE"

if [ -f "$DEST_FILE" ]; then
  echo "Download successful: $DEST_FILE"
  FILE_SIZE=$(stat -c %s "$DEST_FILE")
  if [ "$FILE_SIZE" -gt 0 ]; then
    echo "File size is $FILE_SIZE bytes. The file has been downloaded properly."
  else
    echo "Error: File is empty!"
    exit 1
  fi
else
  echo "Error: Download failed!"
  exit 1
fi

echo "Unzipping fonts..."

TEMP_DIR = "JetBrainsMono"
unzip "$DEST_FILE" -d "$TEMP_DIR"

if [ $? -eq 0 ]; then
  echo "Unzipping successful!"
else
  echo "Error: Unzipping failed!"
  exit 1
fi

echo "Installing fonts..."

mkdir -p "$HOME/.local/share/fonts"
mv "$TEMP_DIR"/*/*.{ttf,otf} "$HOME/.local/share/fonts/"

if [ $? -eq 0 ]; then
  echo "Fonts installed successfully!"
else
  echo "Error: Installing fonts failed!"
  exit 1
fi

echo "Removing temporary files..."

rm -rf "$TEMP_DIR"

echo "Rebuilding font cache..."
fc-cache -fv

echo "Fixing GTK themes..."

if [ -f "./theme-fix.sh" ]; then
  ./theme-fix.sh
  if [ $? -eq 0 ]; then
    echo "theme-fix.sh executed successfully!"
  else
    echo "Error: theme-fix.sh execution failed!"
  fi
else
  echo "Error: theme-fix.sh not found!"
  exit 1
fi

echo "Refreshing Sway..."

swaymsg reload

echo "Installation complete!"





