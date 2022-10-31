SUMMARY = "An image that support HomeAssistant configured as I want it"

IMAGE_FEATURES += "splash ssh-server-openssh bash-completion-pkgs"

IMAGE_INSTALL:append = " \
    tzdata \
	chrony \
"

LICENSE = "MIT"

inherit core-image

# This will create the
# /etc/vconsole.conf
# /etc/locale.conf
#
##
# Uses IMAGE_MPK_DEFAULT_LOCALE is for the locale
# uses IMAGE_MPK_DEFAULT_KB to set the vconsole 

update_locale_and_kb() {
    #
	# Check for IMAGE_MPK_DEFAULT_KB
	if ( -z ${IMAGE_MPK_DEFAULT_KB} ); then
	    bbwarn "IMAGE_MPK_DEFAULT_KB is not set, KEYMAP will not be updated."
	else
	    echo "KEYMAP=${IMAGE_MPK_DEFAULT_KB}" > ${IMAGE_ROOTFS}${sysconfdir}/vconsole.conf
		bbnote "IMAGE_MPK_DEFAULT_KB is set ot ${IMAGE_MPK_DEFAULT_KB}, KEYMAP will be updated"
	fi

	if ( -z ${IMAGE_MPK_DEFAULT_LOCALE} ); then
	    bbwarn "IMAGE_MPK_DEFAULT_LOCALE is not set, default Locale will not be updated."
	else
		echo "LANG=${IMAGE_MPK_DEFAULT_LOCALE}" > ${IMAGE_ROOTFS}${sysconfdir}/locale.conf
		bbnote "IMAGE_MPK_DEFAULT_LOCALE is set and so locale.conf has been updated with \"$IMAGE_MPK_DEFAULT_LOCALE\""
	fi
}

# We want to turn on backup NTP/Sync stuff 
enable_google_time() {
    sed -i 's/^[#[:space:]]*FallbackNTP.*/FallbackNTP=time1.google.com time2.google.com time3.google.com time4.google.com /' ${IMAGE_ROOTFS}${sysconfdir}/systemd/timesyncd.conf
}

# Do some post processing
ROOTFS_POSTPROCESS_COMMAND += "update_locale_and_kb; enable_google_time; ssh_allow_root_login; "
