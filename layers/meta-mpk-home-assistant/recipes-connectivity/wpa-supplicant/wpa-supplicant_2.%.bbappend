#
# Update the WiFi with our version of the config
#

# New file
#
FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"
SRC_URI:append = "\
    file://wpa_supplicant.conf-mpk \
"
SYSTEMD_AUTO_ENABLE = "enable"
SYSTEMD_SERVICE:${PN}:append = " wpa_supplicant-nl80211@wlan0.service  "

do_install:append () {
    #
	# Check if IMAGE_MPK_SSID IMAGE_MPK_SSID_KEY and IMAGE_MPK_SSID_MODE are set
	# if they are, then use the new wpa_supplicant.conf 
    if ( ! -z ${IMAGE_MPK_SSID} ) &&
	   ( ! -z ${IMAGE_MPK_SSID_KEY} ) &&
	   ( ! -z ${IMAGE_MPK_SSID_MODE} ); then

        bbnote "Configuring WiFi with supplied data"
		sed -i -e 's@%SSID%@${IMAGE_MPK_SSID}@' \
		       -e 's@%PASSKEY%@${IMAGE_MPK_SSID_KEY}@' \
			   -e 's@%ENC_MODE%@${IMAGE_MPK_SSID_MODE}@' \
			   ${WORKDIR}/wpa_supplicant.conf-mpk
			   
	    install -d ${D}${sysconfdir}/wpa_supplicant/
   	    install -m 600 ${WORKDIR}/wpa_supplicant.conf-mpk ${D}${sysconfdir}/wpa_supplicant/wpa_supplicant-nl80211-wlan0.conf
    else
	    bbwarn "Wireless configuration is not set, so wpa_supplicant.conf not modified"
    fi
    
   install -d ${D}${sysconfdir}/systemd/system/multi-user.target.wants/
   ln -s ${systemd_unitdir}/system/wpa_supplicant@.service ${D}${sysconfdir}/systemd/system/multi-user.target.wants/wpa_supplicant-nl80211@wlan0
}
