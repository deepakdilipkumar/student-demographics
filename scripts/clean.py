import csv 

department=["","Aerospace","Chemical","Chemistry","Civil","Computer Science","","Electrical","","","Mechanical","Metallurgical","","","","","","Energy","","","","","","","","","Engineering Physics"]

def location(pincode):
	first = str(pincode)[0:2]
	#island = str(pincode)[0:3]
	#if island=="682":
	#	return "Lakshwadeep"
	#elif island =="744":
	#	return "Andaman and Nicobar"
	if first=="11":
		return "Delhi"
	elif first =="12" or first =="13":
		return "Haryana"
	elif first =="14" or first =="15" or first =="16":
		return "Punjab"
	elif first =="17":
		return "Himachal Pradesh"
	elif first =="18" or first =="19":
		return "Jammu and Kashmir"
	elif first >="20" and first <="28":
		return "Uttar Pradesh"
	elif first >="30" and first <="34":
		return "Rajasthan"
	elif first >="36" and first <="39":
		return "Gujarat"
	elif first >="40" and first <="44":
		return "Maharashtra"
	elif first >="45" and first <="48":
		return "Madhya Pradesh"
	elif first =="49":
		return "Chhattisgarh"
	elif first >="50" and first <="53":
		return "Andhra Pradesh/Telangana"
	elif first >="56" and first <="59":
		return "Karnataka"
	elif first >="60" and first <="64":
		return "Tamil Nadu"
	elif first >="67" and first <="69":
		return "Kerala"
	elif first >="70" and first <="74":
		return "West Bengal"
	elif first >="75" and first <="77":
		return "Orissa"	
	elif first =="78":
		return "Assam"
	elif first =="79":
		return "North-Eastern States"
	elif first >="84" and first <="85":
		return "Bihar"
	elif first >="80" and first <="83":
		return "Bihar/Jharkhand"
	elif first =="92":
		return "Jharkhand"

allPinCodes=[]
allRollNos=[]
depts=[]
batch=[]
prog=[]
state=[]


for year in ["2011","2012","2013","2014"]:
	f= open("..//data//old"+year+".csv","rb")
	initialcsv = csv.reader(f)
	for row in initialcsv:
		rno = row[0]
		pin = row[1]
		allRollNos.append(rno)
		allPinCodes.append(pin)
		depts.append(department[int(str(rno)[3:5])])
		if str(rno)[2] == "D":
			prog.append("DD")
		elif str(rno)[2] == "0":
			prog.append("BTech")
		elif str(rno)[2] == "1":
			prog.append("MSc")
		elif str(rno)[2] == "B":
			prog.append("BS")
		else:
			prog.append("NA")
		batch.append(year)
		state.append(location(pin))

c = csv.writer(open("..//data//demographics.csv", "wb"))
c.writerow(["Roll Number","Batch","Department","Programme","Pincode","State"])

print(len(allRollNos))
print(len(batch))
print(len(depts))
print(len(prog))
print(len(allPinCodes))
print(len(state))

for i in range(len(allRollNos)):
	c.writerow([allRollNos[i],batch[i],depts[i],prog[i],allPinCodes[i],state[i]])
