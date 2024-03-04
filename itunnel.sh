#!/bin/bash
clear
echo " "
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
  echo -e  "  \e[31m 1\e[33m =>\033[0m  Quick Tunnel"
  echo -e  "  \e[31m 2\e[33m =>\033[0m  Close Tunnel"
  echo -e  "  \e[31m 3\e[33m =>\033[0m  Enable Auto-Start Tunnel"
  echo -e  "  \e[31m 4\e[33m =>\033[0m  Disable Auto-Start Tunnel"
  echo -e  "  \e[31m 5\e[33m =>\033[0m  Show Public IPv4 / IPv6"
  echo -e  "  \e[31m 6\e[33m =>\033[0m  BenchMark & SpeedTest"
  echo -e  "  \e[31m 0\e[33m =>\033[0m  Exit"
  echo -e  " "
  read -p  " » Please Select Number: " choice
  echo " "
# Quick Tunnel
if [ "$choice" = "1" ] ; then

	wait
	
	if [ -z "$ip" ] || [ -z "$port" ]; then
    echo -e "\e[31m               ──────────────────────────────────\033[0m"
    echo -e " "
    printf "\e[33m [✱] \e[36mEnter the server's IPv4 tunnel direction: \033[0m"
    read ip
    
	until [[ ! -z "$ip" && "$ip" =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]]; do
        echo -e " "
        echo -e "\e[31mError $ip invalid IPv4 address!\033[0m"
        echo -e " "
        printf "\e[33m [✱] \e[36mEnter the server's IPv4 tunnel direction: \033[0m"
        read ip
    done
    
    echo -e " "
    echo -e "\e[31m               ──────────────────────────────────\033[0m"
    echo -e " "
    printf "\e[33m [✱] \e[36mEnter the ports to be forwarded \033[0m"
    read -rp "[80:65535]: " port

    if [ -z "$port" ]; then
    port=80:65535
	else
		until [[ "$port" =~ ^[0-9]+:[0-9]+$ || "$port" =~ ^[0-9]+$ ]]; do
			echo -e " "
			echo -e "\e[31mError, invalid port range. Please enter in the format 'Min:Max' or 'Port'.\033[0m"
			echo -e " "
			printf "\e[33m[✱] \e[36mEnter the ports to tunnel \033[0m"
			read -rp "[80:65535]: " port
		done
	fi

	fi

	iptables -t nat -F
	iptables -t nat -A PREROUTING -p tcp --dport $port -j DNAT --to-destination $ip
	iptables -t nat -A POSTROUTING -j MASQUERADE
	sysctl net.ipv4.ip_forward=1 > /dev/null 2>&1
	
	echo -e " "
	
	wait
	
	echo -e  "\e[31m               ─────────────────────────────────\033[0m"
	echo -e  "\n\e[92m                  Tunneling done successfully \033[0m\n"
	echo -e  "\e[31m               ─────────────────────────────────\033[0m"

# Close Tunnel
elif [ "$choice" = "2" ]; then

	iptables -t nat -F
	
	echo -e  "\e[31m               ─────────────────────────────────\033[0m"
	echo -e  "\n\e[92m                Your tunnel has been cancelled!\033[0m\n"
	echo -e  "\e[31m               ─────────────────────────────────\033[0m"

# Enable Auto-Start Tunnel
elif [ "$choice" = "3" ]; then
	
	wait
	
	if [ -z "$ip" ] || [ -z "$port" ]; then
    echo -e "\e[31m               ──────────────────────────────────\033[0m"
    echo -e " "
    printf "\e[33m [✱] \e[36mEnter the server's IPv4 tunnel direction: \033[0m"
    read ip
    
	until [[ ! -z "$ip" && "$ip" =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]]; do
        echo -e " "
        echo -e "\e[31mError $ip invalid IPv4 address!\033[0m"
        echo -e " "
        printf "\e[33m [✱] \e[36mEnter the server's IPv4 tunnel direction: \033[0m"
        read ip
    done
    
    echo -e " "
    echo -e "\e[31m               ──────────────────────────────────\033[0m"
    echo -e " "
    printf "\e[33m [✱] \e[36mEnter the ports to be forwarded \033[0m"
    read -rp "[80:65535]: " port

    if [ -z "$port" ]; then
    port=80:65535
	else
		until [[ "$port" =~ ^[0-9]+:[0-9]+$ || "$port" =~ ^[0-9]+$ ]]; do
			echo -e " "
			echo -e "\e[31mError, invalid port range. Please enter in the format 'Min:Max' or 'Port'.\033[0m"
			echo -e " "
			printf "\e[33m[✱] \e[36mEnter the ports to tunnel \033[0m"
			read -rp "[80:65535]: " port
		done
	fi

	fi

	iptables -t nat -F
	iptables -t nat -A PREROUTING -p tcp --dport $port -j DNAT --to-destination $ip
	iptables -t nat -A POSTROUTING -j MASQUERADE
	sysctl net.ipv4.ip_forward=1 > /dev/null 2>&1
	
	echo -e " "
		
	rm -rf /etc/rc.local
	echo "# Tunnel IP: ${ip}" >> /etc/rc.local
	echo "#!/bin/sh -e" >> /etc/rc.local
	echo "iptables -t nat -A PREROUTING -p tcp --dport ${port} -j DNAT --to-destination ${ip}" >> /etc/rc.local
	echo "iptables -t nat -A POSTROUTING -j MASQUERADE" >> /etc/rc.local
	echo "sysctl net.ipv4.ip_forward=1" >> /etc/rc.local
	echo "exit 0" >> /etc/rc.local
	
	wait
	
	sudo chmod +x /etc/rc.local
	
	echo -e  "\e[31m               ─────────────────────────────────\033[0m"
	echo -e  "\n\e[92m                  Tunneling done successfully \033[0m\n"
	echo -e  "\e[31m               ─────────────────────────────────\033[0m"

# Disable Auto-Start Tunnel
elif [ "$choice" = "4" ]; then

	iptables -t nat -F
	rm -rf /etc/rc.local
	
	echo -e  "\e[31m               ─────────────────────────────────\033[0m"
	echo -e  "\n\e[92m                Your tunnel has been cancelled!\033[0m\n"
	echo -e  "\e[31m               ─────────────────────────────────\033[0m"
	
# Show Public IPv4
elif [ "$choice" = "5" ]; then

	ipv4=$(curl -4 -s https://ip.hetzner.com)
	ipv6=$(curl -6 -s https://ip.hetzner.com)
	
	if [ -z "$ipv6" ]; then
		ipv6="\e[31mNot Found\033[0m"
	fi
	echo -e  "\e[31m               ──────────────────────────────────\033[0m"
    echo -e  " "
	echo -e  "   \e[33m»\033[0m IPv4:  $ipv4"
	echo -e  "   \e[33m»\033[0m IPv6:  $ipv6"
    echo -e  " "
	echo -e  "\e[31m               ──────────────────────────────────\033[0m"
	
# BenchMark & SpeedTest
elif [ "$choice" = "6" ]; then

	wget -qO- bench.sh | bash

# Exit
elif [ "$choice" = "0" ]; then

clear
exit


else
echo -e "\e[31m Invalid Command! \033[0m"
echo -e " "
fi
