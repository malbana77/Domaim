#!/bin/bash
echo ''
echo '▓█████▄  ▒█████   ███▄ ▄███▓ ▄▄▄       ██▓ ███▄ ▄███▓
▒██▀ ██▌▒██▒  ██▒▓██▒▀█▀ ██▒▒████▄    ▓██▒▓██▒▀█▀ ██▒
░██   █▌▒██░  ██▒▓██    ▓██░▒██  ▀█▄  ▒██▒▓██    ▓██░
░▓█▄   ▌▒██   ██░▒██    ▒██ ░██▄▄▄▄██ ░██░▒██    ▒██ 
░▒████▓ ░ ████▓▒░▒██▒   ░██▒ ▓█   ▓██▒░██░▒██▒   ░██▒
 ▒▒▓  ▒ ░ ▒░▒░▒░ ░ ▒░   ░  ░ ▒▒   ▓▒█░░▓  ░ ▒░   ░  ░
 ░ ▒  ▒   ░ ▒ ▒░ ░  ░      ░  ▒   ▒▒ ░ ▒ ░░  ░      ░
 ░ ░  ░ ░ ░ ░ ▒  ░      ░     ░   ▒    ▒ ░░      ░   
   ░        ░ ░         ░         ░  ░ ░         ░   
 ░                                                   '
echo ''
PS3="Enter your choose :# " export PS3
select loop in 'Domain' 'URL'
do
if [ "$loop" == 'Domain' ]
then
	printf "Please Enter The Domain : "
	read -r Domain
	nd=$(tr -dc '.' <<<"$Domain" | awk '{ print length; }')
	ip=$(host -t A $Domain | cut -d " " -f 4)
	if [ $nd -eq '1' ] 
	then
		if [ $ip = "A" ] 2>/dev/null
		then
			echo 'the domain is incorrect try URL mode'
			exit
		fi
		echo -e "\n\e[1m\e[93m[-] IP ADDRESS: \e[0m"$ip
		mkdir $Domain 2>/dev/null
		cd $Domain
		rm -r *.* 2>/dev/null #To remove anything in folder
	   #WHOIS
		whois $Domain >.whois.txt
		cat .whois.txt | grep "   Creation Date:" | cut -d " " -f 4->>whois.txt
		cat .whois.txt | grep "   Updated Date:"  | cut -d " " -f 4->>whois.txt
		cat .whois.txt | grep "   Registry Expiry Date:"  | cut -d " " -f 4->>whois.txt
		cat .whois.txt | grep "   Name Server:"  | cut -d " " -f 4->>whois.txt
		host -t mx $Domain | grep -v "has no MX record" | grep -v "not found" | awk -F "0" '{print $2}' > .mx.txt
		file=.mx.txt
		while read line ; do
			echo 'Mail Server: '$line >>whois.txt
		done < ${file}
		cat .whois.txt | grep "Tech" >>whois.txt
		echo -e "\e[1m\e[93m[-] About Domain:\e[0m"
		cat whois.txt &&rm .whois.txt
		python3 ../Fans.py -d $Domain | grep "\S"> AS.txt
		printf 'Autonomous system: ' 
		cat AS.txt
		as=$(echo $as | cut -d " " -f 1)
		ci=$(whois $ip | grep "CIDR"|grep -Eo "([0-9.]+){4}/[0-9]+")  
		echo 'CIDR: '$ci
		printf "Zone Transfer: "
		for n in $(host -t ns $Domain | cut -d " " -f 4 );do
			host -l $Domain $n > .z.txt
			cat .z.txt | grep "has address" >>zone.txt
		done
		if [ -s zone.txt ] 
		then
			echo ""
			cat zone.txt
		else
			echo "Failed"
			rm zone.txt
		fi
	#######################
	   #Subdomains
	   	echo -e "\e[1m\e[93m[-] Subdomains: \e[0m"
		theHarvester -d $Domain -b bufferoverun,crtsh,dnsdumpster,otx,sublist3r >.sub.txt
		cat .sub.txt | grep "$Domain" | grep -v "*" | grep -v "/" > subdomain.txt
		cat subdomain.txt

	#######################
	   #Emails
	   	echo -e "\e[1m\e[93m[-] Emails :\e[0m"
		theHarvester -d $Domain -b bing,duckduckgo,google,yahoo,baidu,exalead > .em.txt
		cat .em.txt | grep "@" | grep -v "cmartorella@edge-security.com">> emails.txt
		cat emails.txt
	else
		echo 'This Domain is incorrect try URL mode'
		exit
	fi
	for i in {243..248} {248..243} ; do echo -en "\e[38;5;${i}m######\e[0m" ; done ; echo
	echo "NOTE:We create a folder have name '$Domain' you can see all this details there."
	exit
elif [ "$loop" == 'URL' ]
then
	printf "Please Enter The URL : "
	read -r url
	nd=$(tr -dc '.' <<<"$url" | awk '{ print length; }')
	ip=$(host -t A $url | cut -d " " -f 4)
	if [ $nd -eq '2' ]
	then
		echo -e "\n\e[1m\e[93m[-] IP ADDRESS: \e[0m"$ip
		mkdir $url 2>/dev/null
		cd $url
		rm -r *.* 2>/dev/null #To remove anything in folder
	   #WHOIS
	   	Domain=$(echo $url |cut -d "." -f 2,3)
		whois $Domain >.whois.txt
		cat .whois.txt | grep "   Creation Date:" | cut -d " " -f 4->>whois.txt
		cat .whois.txt | grep "   Updated Date:"  | cut -d " " -f 4->>whois.txt
		cat .whois.txt | grep "   Registry Expiry Date:"  | cut -d " " -f 4->>whois.txt
		cat .whois.txt | grep "   Name Server:"  | cut -d " " -f 4->>whois.txt
		host -t mx $Domain | grep -v "has no MX record" | grep -v "not found" | awk -F "0" '{print $2}' > .mx.txt
		file=.mx.txt
		while read line ; do
			echo 'Mail Server: '$line >>whois.txt
		done < ${file}
		cat .whois.txt | grep "Tech" >>whois.txt
		echo -e "\e[1m\e[93m[-] About Domain:\e[0m"
		cat whois.txt &&rm .whois.txt
		python3 ../Fans.py -d $url | grep "\S"> AS.txt
		printf 'Autonomous system: ' 
		cat AS.txt
		ci=$(whois $ip | grep "CIDR"|grep -Eo "([0-9.]+){4}/[0-9]+")  
		echo 'CIDR: '$ci
		printf "Zone Transfer: "
		for n in $(host -t ns $Domain | cut -d " " -f 4 );do
			host -l $Domain $n > .z.txt
			cat .z.txt | grep "has address" >>zone.txt
		done
		if [ -s zone.txt ] 
		then
			echo ""
			cat zone.txt
		else
			echo "Failed"
			rm zone.txt
		fi
	#######################
	   #Subdomains
	   	echo -e "\e[1m\e[93m[-] Subdomains: \e[0m"
		theHarvester -d $Domain -b bufferoverun,crtsh,dnsdumpster,otx,sublist3r >.sub.txt
		cat .sub.txt | grep "$Domain" | grep -v "*" | grep -v "/" > subdomain.txt
		cat subdomain.txt


	#######################
	   #Emails
	   	echo -e "\e[1m\e[93m[-] Emails :\e[0m"
		theHarvester -d $Domain -b bing,duckduckgo,google,yahoo,baidu,exalead > .em.txt
		cat .em.txt | grep "@" | grep -v "cmartorella@edge-security.com">> emails.txt
		cat emails.txt
		
		
	else
		echo 'the URL is incorrect. Enter full url not just domain'
		exit
	fi
	for i in {243..248} {248..243} ; do echo -en "\e[38;5;${i}m######\e[0m" ; done ; echo
	echo "NOTE:We create a folder have name '$Domain' you can see all this details there."
	exit
fi
done
