
# Add paths for the krb5 package
if [ -d /usr/lib/mit/bin ]; then
    COUNT=`ls -1 /usr/lib/mit/bin/ | wc -l`
    if [ $COUNT -gt 0 ]; then
        PATH="$PATH:/usr/lib/mit/bin"
    fi
fi
if [ -d /usr/lib/mit/sbin ]; then
    COUNT=`ls -1 /usr/lib/mit/sbin/ | wc -l`
    if [ $COUNT -gt 0 ]; then
        PATH="$PATH:/usr/lib/mit/sbin"
    fi
fi
export PATH=$PATH

