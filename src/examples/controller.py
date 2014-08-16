# (c) Alexandru Ioan Pop@2014 aip.messages@yahoo.co.uk
# github.com/alexandruioanp
import serial
import atexit
import sys

def getByte(number):	#converts the number to a byte that can be send by serial
	return chr(int(bin(number)[2:],2)) 

def pad(str):	#returns a string padded with zeroes, ensuring "propper" 8-bit appearance
	return '0'*(8-len(str))+str

def count(DATA):	#counts number of consecutive equal values in DATA; used for compressed VCD generation
	OUT=[]
	i=0
	while i<1022:
		curr=DATA[i]
		count=1
		i+=1
		while curr==DATA[i] and i<=1022:
			count+=1
			i=i+1
		OUT.append([DATA[i], count])
	return OUT

def exit_handler():    #closes the open file and port
    global ser
    ser.close()
    global f
    f.close()

def main():
	if len(sys.argv)!=4:
		 sys.exit('Usage: %s target-file port baud' % sys.argv[0])
	file_path=sys.argv[1]

	atexit.register(exit_handler)

	global ser
	ser=serial.Serial()
	ser.port=sys.argv[2]
	ser.baudrate=int(sys.argv[3])
	ser.timeout=1
	if ser.isOpen():
	    ser.close()
	ser.open()

	MASK=""
	COND=""
	read=['0', '0', '0', '0']

	global f
	f=open(sys.argv[1], 'w')
	f.write("""
$comment aip.messages@yahoo.co.uk $end
$timescale 10ns $end
$scope module logic_analyzer $end
$var wire 8 # DATA $end
$enddefinitions $end
#0\n""")	#some of these headers are required by the VCD standard

	command=raw_input("1. SET_TRIG_COND\n2. CHECK_TRIG\n3. FORCE_TRIG\n4. READ\n5. MONITOR\nx. EXIT\n")

	while(command!="x"):
		if(command=="1"):
			print "2-byte MASK, 2-byte COND"
			ser.write(getByte(1))
			for i in xrange(4):
				read[i]=int(raw_input())
			for i in xrange(4):
				ser.write(getByte(read[i]))
		elif(command=="2"):
			ser.write(getByte(2))
			checkTriggered=ser.read(1)
			if ord(checkTriggered):
				print "TRIGGERED"
			else:
			 	print "NOT TRIGGERED"
		elif(command=="3"):
			ser.write(getByte(3))
		elif(command=="4"):
			ser.write(getByte(4))
			RAM_DATA=ser.read(1024)
			cnt=count(RAM_DATA)
			i=0
			for c in cnt:
				f.write('b'+pad(bin(ord(c[0]))[2:])+' #\n')
				f.write('#'+str(c[1]*i)+'\n')
				i=i+1
		elif(command=="5"):    #continuously reset the trigger condition, then force the trigger and read the RAM
			while True:
				ser.write(getByte(1))
				for i in xrange(16):
					ser.write(getByte(0))
				ser.write(getByte(3))
				ser.write(getByte(4))
				RAM_DATA=ser.read(1024)
				for c in RAM_DATA:
					print pad(bin(ord(c))[2:])
		command=raw_input()

if __name__ == "__main__":
    main()