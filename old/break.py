#!/usr/bin/env python


import os

code_started = False

file = ""
with open('todo_1.md', 'r') as file:
    for line in file:
        # lc = lc + 1
        # if start < lc < end:
        line2 = line.strip()
        parts = line2.split(' ')
        if (parts[0])[:3] == '```':
            code_started = not(code_started)
            # print("code started", code_started, line)
        if parts[0] == '#' and code_started == False:
            print(line)
            name = input('Filename: ')
            file = name + ".md"
        with open('cleaned/' + file, "a") as f:
            f.write(line)
        # print(line)





