# Add some features.
do_deploy:append() {
    # Enable i2c by default
    echo "dtparam=i2c_arm=on" >>${DEPLOYDIR}/bootfiles/config.txt
    # Enable SPI by default
    # echo "dtparam=spi=on" >>${DEPLOYDIR}/bootfiles/config.txt
    # Disable firmware splash by default
    echo "disable_splash=1" >>${DEPLOYDIR}/bootfiles/config.txt
    # Disable firmware warnings showing in non-debug images
    if ! ${@bb.utils.contains('DISTRO_FEATURES','osdev-image','true','false',d)}; then
        echo "avoid_warnings=1" >>${DEPLOYDIR}/bootfiles/config.txt
    fi
    # Enable audio (loads snd_bcm2835)
    echo "dtparam=audio=on" >> ${DEPLOYDIR}/bootfiles/config.txt
}
# Enable clock overlay

do_deploy:append:raspberrypi4() {
	# Use the dt overlays required by the UniPi Neuron family of boards
	echo "dtoverlay=i2c-rtc,ds3231" >> ${DEPLOYDIR}/bootfiles/config.txt
}
