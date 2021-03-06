#!/usr/bin/env python3

import sys
import subprocess

""" mp3 splitting with timestamp file 
    Usage: python3 filename.py full.mp3 timestamp_file
    timestap_file: name first, start-time last, separator '-'. Index optional.
    Sample:
    Name1 - 04:35
    2. Name - 05:35
"""

inputfile = sys.argv[1]
codec = '-acodec'

#ffmpeg did not like having '?' in the file name, add any other problematic symbol here.
escape_list = ['?']

def RemoveSymbols(text):
    for symbol in escape_list:
        text = text.replace(symbol, '')
    return text

tracklist = []

class Track:
    def __init__(self, timestamp, name):
        self.timestamp = timestamp
        self.name = name

class ExtractTracks:
    def __init__(self):
        with open(sys.argv[2], "r") as values:
            for value in values:
                name = ""
                timestamp = ""
                #split all by spaces.
                # keyVal = value.split(' ')
                keyVal = value.split('-')
                #find timestamp
                for word in keyVal:
                    if ':' in word:
                        timestamp = word
                    else:
                        name += word + ' '
                tracklist.append(Track(timestamp, name))

#Initialize
ExtractTracks()


def GenerateSplitCommand(start, end, filename):
    return ['ffmpeg', '-i', inputfile, '-ss', start, '-to', end, '-c', 'copy', filename+'.mp3', '-v', 'error']

def GetVideoEnd():
    ffprobeCommand = [
        'ffprobe',
        '-v',
        'error',
        '-show_entries',
        'format=duration',
        '-of',
        'default=noprint_wrappers=1:nokey=1',
        '-sexagesimal',
        inputfile
    ]
    return subprocess.check_output(ffprobeCommand).strip()

for i in range(0, len(tracklist)):
    name = tracklist[i].name.strip()
    name = RemoveSymbols(name)
    startTime = tracklist[i].timestamp.strip()
    if i != (len(tracklist) - 1):
        endTime = tracklist[i+1].timestamp.strip() #- startTime
    else:
        endTime = GetVideoEnd() #- startTime
        endTime = endTime.decode("utf-8")
    print('---')
    print('Generating \"' + name + '\" from ' + startTime + ' to ' + endTime)
    print('---')
    command = GenerateSplitCommand(str(startTime), str(endTime), name)
    output = subprocess.check_call(command)
