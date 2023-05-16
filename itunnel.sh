#!/bin/bash

clear

echo ""

echo -e "\e[35m
     ██╗████████╗██╗░░░██╗███╗░░██╗███╗░░██╗███████╗██╗░░░░░
     ██║╚══██╔══╝██║░░░██║████╗░██║████╗░██║██╔════╝██║░░░░░
     ██║░░░██║░░░██║░░░██║██╔██╗██║██╔██╗██║█████╗░░██║░░░░░
     ██║░░░██║░░░██║░░░██║██║╚████║██║╚████║██╔══╝░░██║░░░░░
     ██║░░░██║░░░╚██████╔╝██║░╚███║██║░╚███║███████╗███████╗
     ╚═╝░░░╚═╝░░░░╚═════╝░╚═╝░░╚══╝╚═╝░░╚══╝╚══════╝╚══════╝
\033[0m"

if [ "$(id -u)" -ne 0 ]; then
    echo -e "\n\033[33mRUN AS ROOT!\033[0m"
    exit
fi

  echo -e  "\e[31m               ──────────────────────────────────\033[0m"
  echo -e  "\e[31m                        「ITUNNEL MENU 」          \033[0m"
  echo -e  "\e[31m               ──────────────────────────────────\033[0m"
  echo -e  ""
  echo -e  "  \e[31m 1\e[33m  =>\033[0m Tunnel"
  echo -e  "  \e[31m 2\e[33m  =>\033[0m Cancel Tunnel"
  echo -e  "  \e[31m 0\e[33m  =>\033[0m Exit"
  echo -e  " "
  read -p  " » Please Select Number: " choice
  echo " "
  
# Tunnel
if [ "$choice" = "1" ] ; then

	wait
	
	if [ "$ip" = "" ] || [ "$port" = "" ] ; then
		echo -e "\e[31m               ──────────────────────────────────\033[0m"
		echo -e " "
		printf "\e[33m [✱] \e[36mEnter the IP that should be forwarded: \033[0m"
		read ip
		[[ -z "$ip" ]]
		
		echo -e " "
		echo -e "\e[31m               ──────────────────────────────────\033[0m"
		echo -e " "
		printf "\e[33m [✱] \e[36mEnter the ports to be forwarded \033[0m"
		read -rp "[80:65535]: " port
		until [[ -z "$port" || "$port" =~ ^[0-9]+$ && "$port" -le 65535 ]]; do
			echo "$port: invalid port."
		done
		[[ -z "$port" ]] && port=80:65535
	else
		port=80:65535
	fi	
	
	iptables -t nat -F
	iptables -t nat -A PREROUTING -p tcp --dport $port -j DNAT --to-destination $ip
	iptables -t nat -A POSTROUTING -j MASQUERADE
	sysctl net.ipv4.ip_forward=1
	
	echo -e " "
	
	rm -rf /etc/rc.local
	echo "#!/bin/sh -e" >> /etc/rc.local
	echo "iptables -t nat -A PREROUTING -p tcp --dport ${port} -j DNAT --to-destination ${ip}" >> /etc/rc.local
	echo "iptables -t nat -A POSTROUTING -j MASQUERADE" >> /etc/rc.local
	echo "sysctl net.ipv4.ip_forward=1" >> /etc/rc.local
	echo "exit 0" >> /etc/rc.local

	chmod +x /etc/rc.local
	
	wait
	
	echo -e  "\e[31m               ─────────────────────────────────\033[0m"
	echo -e  "\n\e[92m                  Tunneling done successfully \033[0m\n"
	echo -e  "\e[31m               ─────────────────────────────────\033[0m"

# Cancel Tunnel
elif [ "$choice" = "2" ]; then

	iptables -t nat -F
	rm -rf /etc/rc.local
	
	echo -e  "\e[31m               ─────────────────────────────────\033[0m"
	echo -e  "\n\e[92m                Your tunnel has been cancelled!\033[0m\n"
	echo -e  "\e[31m               ─────────────────────────────────\033[0m"
	
# Exit
elif [ "$choice" = "0" ]; then

exit

else
echo -e "\e[31m Invalid Command! \033[0m"
echo -e " "
fi
