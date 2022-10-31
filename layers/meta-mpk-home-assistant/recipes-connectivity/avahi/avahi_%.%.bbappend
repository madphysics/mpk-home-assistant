#
# Add a service to advertise some ssh stuff
#

do_install:append() {
    # reinstall the ssh service
    cp ${D}${docdir}/avahi/ssh.service ${D}${sysconfdir}/avahi/services
    cp ${D}${docdir}/avahi/sftp-ssh.service ${D}${sysconfdir}/avahi/services

}
