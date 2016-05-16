import re
import csv

with open("2012.txt") as f:
	content=f.readlines()

rollNo=[None]*600
pincode=[None]*600
regexRollNumber = re.compile("\D([0-9]{2}.[0-9]{6})\D")
regexPincode= re.compile("\D([0-9]{6})\D")
#regexMob = re.compile("[0-9]{10}")
rollindex = 0
pinindex = 0


for line in content: 
	if ( regexRollNumber.search(line)):  # Roll number
		if (rollindex > pinindex ):		 # Some pin code was missing
			pinindex+=1

		rollNo[rollindex] = regexRollNumber.findall(line)[0]
		rollindex+=1


	else:
		if (regexPincode.search(line) and rollindex>pinindex):    #Pin Code, and to avoid pin code duplication
			pincode[pinindex] = regexPincode.findall(line)[0] 
			pinindex+=1

print rollNo[len(rollNo)-1]
print pincode[len(pincode)-1]
print len(rollNo)
print len(pincode)

c = csv.writer(open("2012.csv", "wb"))
c.writerow(["Roll Number","Pincode"])

for i in range(len(rollNo)):
	c.writerow([rollNo[i],pincode[i]])

