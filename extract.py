import re

with open("2012.txt") as f:
	content=f.readlines()

rollNo=[]
pincode=[]
regexRollNumber = re.compile("[0-9]{2}.[0-9]{6}")
regexPincode= re.compile("[0-9]{6}")

for line in content: 
	if ( regexRollNumber.search(line)):  # Roll number
		rollNo.append( regexRollNumber.search(line).group(0)  )

	else:
		if (regexPincode.search(line)):    #Pin Code
			pincode.append( regexPincode.search(line).group(0) ) 


print rollNo[len(rollNo)-1]
print pincode[len(pincode)-1]
print len(rollNo)
print len(pincode)