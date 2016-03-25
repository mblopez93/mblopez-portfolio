#!/usr/bin/python
# encoding=utf8
import subprocess

x=raw_input("Press R to record:  ")

if x == "R":
	print('You pressed R')
	cmd = ['arecord', '-f', 'S16_LE', '-r', '8000', '-D', 'default', 'recordx.wav']
        process = subprocess.Popen(cmd, stdout=subprocess.PIPE)
	x=raw_input('Press S to stop recording: ')
	if x == "S":
		print('You pressed S')
		process.terminate()
		x=raw_input('Press P to process in continuous: ')
		if x == "P":
        		print('You pressed P')
			cmd = ['./continuous', '-samprate', '8000', '-infile', 'recordx.wav'] 
			process = subprocess.Popen(cmd, stdout=subprocess.PIPE)
			for line in iter(process.stdout.readline, b''):
    				print line,
			process.stdout.close()
			process.wait()