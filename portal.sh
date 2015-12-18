#
# NJU portal login script
#
cachefile=$HOME/.cache/.portal

login() {
    if [[ -f $cachefile ]]; then
        readarray np < $cachefile
        username=${np[0]}
        password=${np[1]}
    else
        read -p "username:" username
        read -s -p "password:" password
        mkdir -p `dirname $cachefile`
        echo $username > $cachefile
        echo $password >> $cachefile
    fi
    curl -Ss -X POST "http://p.nju.edu.cn/portal_io/login" -d username=$username -d password=$password
}

logout() {
    curl -Ss -X POST "http://p.nju.edu.cn/portal_io/logout"
}

if [[ $1 == "out" ]]; then
    logout
else
    login
fi
