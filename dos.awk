#https://www.facebook.com/nixcraft/photos/a.431194973560553.114666.126000117413375/909858525694193/?type=1&theater
#source from https://raw.githubusercontent.com/plone/ploneorg.admin/master/sysadmin/scripts/dos.awk
#uzycie:
#tail -n 1000 /var/log/nginx/cyberciti.biz/www.cyberciti.biz_access.log | awk -f dos.awk | sort -nrk3|less | less 
#uruchamiac z getddos.sh
# creates a histogram of values in the first column of piped-in data
function max(arr, big) {
    big = 0;
    for (i in cat) {
        if (cat[i] > big) { big=cat[i]; }
    }
    return big
}

NF > 0 {
    cat[$1]++;
}
END {
    maxm = max(cat);
    for (i in cat) {
        scaled = 60 * cat[i] / maxm;
        printf "%-25.25s  [%8d]:", i, cat[i]
        for (i=0; i<scaled; i++) {
            printf "#";
        }
        printf "\n";
    }
}

