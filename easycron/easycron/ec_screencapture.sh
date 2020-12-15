# Capture the contents of the screen, including the cursor, and attach the resulting image (named 'image.png') to a new Mail message:
# screencapture -C -M image.png

# Select a window using your mouse, then capture its contents without the window's drop shadow and copy the image to the clipboard:

# screencapture -c -W

# Capture the screen after a delay of 10 seconds and then open the new image in Preview:

# screencapture -T 10 -P image.png

# Select a portion of the screen with your mouse, capture its contents, and save the image as a pdf:

# screencapture -s -t pdf image.pdf

# To see more options, type screencapture --help
