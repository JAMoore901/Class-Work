import pyautogui
pyautogui.moveTo(520, 1050, duration=1.5)
pyautogui.click(520, 1050, duration=1.5)
pyautogui.click(700, 150, duration=1.5)
pyautogui.typewrite('cmd')
pyautogui.press('enter')
pyautogui.click(500, 350, duration=1.5)
pyautogui.typewrite('ipconfig/ all')
pyautogui.press('enter')
