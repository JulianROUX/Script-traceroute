ttl=1
args=( "-T -p 8080" "-I" "-U -p 20" "-T -p 443" "-T -p 80" "-T -p 21" "-T -p 22" "-T -p 23" "-I" "-U -p 53" )
ipdest=$(ping -c 1 -4 $1 |head -n 1| awk -F'[()]' '{print$2}')
rm carte$2.rte
echo "\"Adresse $2:($1) \"->" >> carte$2.rte
while [ "$ipa" != "$ipdest" ]
do
        for argument in "${args[@]}"
        do
                ipa=$(traceroute -n $argument -m $ttl -f $ttl -q 1 "$1" | tail -n 1 | awk '{print $2}' | sed "s/*/erreur/g")
                AS=$(traceroute -A $argument -m $ttl -f $ttl -q 1 "$1" | awk '{print $4}' |tail -n 1 )
		echo teste avec $argument && echo $AS
                if [[ "$ipa" != "erreur" ]]; then
                        break
                elif [[ "$argument" == "-U -p 53" ]]; then
                echo "Impossible d'avoir une réponse du routeur"
                echo "\"$1 n'a pas donné de réponse\" ;" >> carte$2.rte
		exit
                fi
        done
        echo avec $argument Réponse
        echo $ipa
	echo -e "\"$ipa $AS\" -> " >> carte$2.rte
        ((ttl++))

done
sed -i '$d' carte$2.rte
echo "\"$ipa $AS($1)\" ; " >> carte$2.rte
