function initArbeit() {

	vpnId="a22edce7-6cef-4eba-983c-d1952dae4294"
	vpnDevice="vpn0"
	rmatePort=52698
	remoteHost="sefu.test"
	xDebug=9000
	xDebug=""
	mountDir="Code/Kompetenztest"
	mountDir=""

	if [[ "$(cat /proc/$(echo -n $(ps -o ppid= -p $$))/cmdline | xargs --null basename -a | tail -1)" == "tilda" ]]; then
		echo "Führe Skript in eigenem Fenster aus"
		( terminator -e "source .zsh/arbeit.sh && initArbeit" & ) 2>/dev/null
		return 0
	fi
	if [[ $(ip -4 address show dev $vpnDevice | grep '10.232.' | wc -l) -ne 1 ]]; then
		echo "Verbinde mit VPN"
		nmcli connection up uuid $vpnId
	else
		echo "Bereits mit VPN verbunden"
	fi

	# if "$(curl -s "http://141.35.244.159:8000/netstat.php?ID=1" | pup text{})" != "online" ]]; then
	# 	if [[ "$(curl -s "http://141.35.244.159:8000/wake_up.php?ID=1" | md5sum | cut -d' ' -f1)" != "0653aa7623a5afd5ac832e8b856f67a2" ]]; then
	# 		echo "Kann Rechner nicht wecken" >2
    #                     return 1
	# 	else
	# 		echo -n "wecke Rechner: "
	# 	fi
	# 	let w=0
	# 	while [[ "$(curl -s "http://141.35.244.159:8000/netstat.php?ID=1" | pup text{})" != "online" ]]; do
	# 		echo -n "•";     sleep .2s;
	# 		echo -ne "\b\\"; sleep .2s;
	# 		echo -ne "\b|";  sleep .2s;
	# 		echo -ne "\b/";  sleep .2s;
	# 		echo -ne "\b-";  sleep .2s;
	# 		echo -ne "\b\\"; sleep .2s;
	# 		echo -ne "\b|";  sleep .2s;
	# 		echo -ne "\b/";  sleep .2s;
	# 		echo -ne "\b-";  sleep .2s;
	# 		echo -ne "\b\\"; sleep .2s;
	# 		echo -ne "\b>";
	# 		let w=$[w + 2]
	# 	done
	# 	echo " Rechner ist online (nach $w Sekunden)"
	# else
	# 	echo "Rechner ist online"
	# fi

	let w=0
	while ! ssh -o ConnectTimeout=1 arbeit exit 2>/dev/null; do
		 echo -n "•";     sleep .1s;
                 echo -ne "\b\\"; sleep .1s;
                 echo -ne "\b|";  sleep .1s;
                 echo -ne "\b/";  sleep .1s;
                 echo -ne "\b-";  sleep .1s;
                 echo -ne "\b\\"; sleep .1s;
                 echo -ne "\b|";  sleep .1s;
                 echo -ne "\b/";  sleep .1s;
                 echo -ne "\b-";  sleep .1s;
                 echo -ne "\b\\"; sleep .1s;
                 echo -ne "\b>";
                 let w=$[w + 2]
	done
	echo "SSH ist erreichbar (nach $w Sekunden)"

	sudo true

	echo "HTTP-Server"
	sudo -E ssh -F ~/.ssh/config -fN -L 80:$remoteHost:80 ber@arbeit

	echo "Master Verbindung"
	ssh -M -fN arbeit

	echo "rmate/subl"
	ssh -O forward -R ${rmatePort}:localhost:${rmatePort} arbeit

	if [[ -n $xDebug ]]; then
		echo "XDebug"
		ssh -O forward -R 0.0.0.0:${xDebug}:localhost:${xDebug} arbeit
	fi

	if [[ -n "$mountDir" ]]; then
		echo "~kt -> ~/${mountDir}"
		sshfs ber@arbeit:${mountDir}/ ~/${mountDir}
	fi

	if [[ $(ps x | grep /opt/sublime_text/sublime_text | grep -v grep | wc -l) -eq 0 ]]; then
		echo "keine Sublime-Instanz gefunden, starte eine"
		( subl ~/${mountDir} & )
	fi

	ssh arbeit
	# echo "--------------------------------------"
	# ssh arbeit "cd $mountDir/servercfg; docker-compose up --force-recreate"
	# echo "--------------------------------------"

	echo "Rollback"
	sudo true

	if [[ -n "$mountDir" ]]; then
		echo "umount ~kt -> ~/${mountDir}"
		sudo umount ~/${mountDir}
	fi

	if [[ -n $xDebug ]]; then
		echo "stop XDebug"
	fi
	echo "stop rmate/subl"
	ssh -O exit arbeit

	echo "stop HTTP-Server"
	sudo -E ssh -F ~/.ssh/config -O exit arbeit

	echo "Beende VPN Verbindung"
	nmcli connection down uuid $vpnId
}
