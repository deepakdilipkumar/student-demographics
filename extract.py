import re
import csv

year = "2011"

with open(year+".txt") as f:
	content=f.readlines()

rollNo=[]
pincode=[]
regexRollNumber = re.compile("\D([0-9]{2}.[0-9]{6})\D")
regexPincode= re.compile("\D([0-9]{6})\D")
#regexMob = re.compile("[0-9]{10}")
rollindex = 0
pinindex = 0
howmany=0

for line in content: 
	if ( regexRollNumber.search(line)):  # Roll number
		if (rollindex > pinindex ):		 # Some pin code was missing
			howmany+=1
			pinindex+=1
			pincode.append('')

		rollNo.append(regexRollNumber.findall(line)[0])
		rollindex+=1

	else:
		if (regexPincode.search(line) and rollindex>pinindex):    #Pin Code, and to avoid pin code duplication
			pincode.append(regexPincode.findall(line)[0] )
			pinindex+=1

print howmany

c = csv.writer(open(year+".csv", "wb"))
c.writerow(["Roll Number","Pincode"])

for i in range(len(rollNo)):
	c.writerow([rollNo[i],pincode[i]])

