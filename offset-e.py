import cv2
import numpy as np

# Load the main image
main_image = cv2.imread('electric.flat.png')
# Convert it to grayscale
main_gray = cv2.cvtColor(main_image, cv2.COLOR_BGR2GRAY)

# Load the pattern image
pattern_image = cv2.imread('template.electric.png', 0)

# Perform template matching
result = cv2.matchTemplate(main_gray, pattern_image, cv2.TM_CCOEFF_NORMED)

loc = np.where(result == np.max(result))
pos = list(zip(*loc[::-1]))[0]

print("{}x{}+{}+{}".format(
    280, 70, # width x height
    pos[0] + 351, # horizontal offset
    pos[1] + 260 # vertical offset
), end='')
