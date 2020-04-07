s=str(input())
sep=" "
i=0
while(i<len(s)):
 if(s[i] == "a" and s[i+1]=="d" and s[i+2] == "d"):
	 print('0000',end='')
	 i=i+6
	 print("{0:03b}".format(int(s[i])), end = '')
	 i=i+2
	 print("{0:03b}".format(int(s[i])), end = '')
	 i=i-4
	 print("{0:03b}".format(int(s[i])), end = '')
	 i=i+5
	 print('000')
 if(s[i] == "a" and s[i+1]=="d" and s[i+2] == "c"):
	 print('0000',end='')
	 i=i+6
	 print("{0:03b}".format(int(s[i])), end = '')
	 i=i+2
	 print("{0:03b}".format(int(s[i])), end = '')
	 i=i-4
	 print("{0:03b}".format(int(s[i])), end = '')
     #i=i+5
	 print('010')
 i=i+5