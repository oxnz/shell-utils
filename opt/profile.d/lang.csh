#
# lang.csh:	Set interactive language environment
#
# Used configuration files:
#
#     /etc/sysconfig/language
#     $HOME/.i18n
#

#
# Already done by the remote SSH side
#
if ( ${?SSH_SENDS_LOCALE} ) goto end

#
# Already done by the GDM
#
if ( ${?GDM_LANG} ) goto end

#
# Get the system and after that the users configuration
#
if ( -s /etc/sysconfig/language ) then
    eval `sed -n \
	-e 's/^RC_\(\(LANG\|LC_[A-Z_]\+\)\)=/set \1=/p' \
	-e 's/^\(ROOT_USES_LANG\)=/set \1=/p' \
	< /etc/sysconfig/language`
    if ( "$uid" != 0 ) set ROOT_USES_LANG=yes
endif
if ( -s $HOME/.i18n ) then
    eval `sed -n \
	-e 's/^\(\(LANG\|LC_[A-Z_]\+\)\)=/set \1=/p' \
	< $HOME/.i18n`
endif

#
# Handle all LC and the LANG variable
#
foreach lc (LANG LC_CTYPE LC_NUMERIC LC_TIME	\
	    LC_COLLATE LC_MONETARY LC_MESSAGES	\
	    LC_PAPER LC_NAME LC_ADDRESS 	\
	    LC_TELEPHONE LC_MEASUREMENT		\
	    LC_IDENTIFICATION LC_ALL)
    eval set val=\${\?$lc}
    if ( $val == 0 ) continue
    eval set val=\$$lc
    if  ( "$ROOT_USES_LANG" == "yes" ) then
	if ( ${%val} == 0 ) then
	    eval unsetenv $lc
	else
	    eval setenv $lc $val
	endif
    else if ( "$ROOT_USES_LANG" == "ctype" ) then
	if ( "$lc" == "LANG" ) continue
	if ( "$lc" == "LC_CTYPE" ) then
	    setenv LC_CTYPE $LANG
	    setenv LANG POSIX
	else
	    eval unsetenv $lc
	endif
    else
	if ( "$lc" == "LANG" ) then
	    setenv LANG POSIX
	else
	    eval unsetenv $lc
	endif
    endif
    eval unset $lc
end

#
# Special LC_ALL handling because the LC_ALL
# overwrites all LC but not the LANG variable
#
if ( ${?LC_ALL} ) then
    set LC_ALL=$LC_ALL
    if ( ${%LC_ALL} > 0 && "$LC_ALL" != "$LANG" ) then
	setenv LC_ALL $LC_ALL
    else
	unsetenv LC_ALL
    endif
    unset LC_ALL
endif

unset ROOT_USES_LANG lc val
end:
#
# end of lang.sh
