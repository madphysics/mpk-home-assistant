DESCRIPTION = "Install Root SSH keys"
LICENSE="MIT"

do_install () {
    install -d ${D}/home/root/.ssh
	# create a blank one
	touch ${WORKDIR}/authorized_keys
	# check if user supplied any more?
	if ( ! -z ${IMAGE_MPK_ROOT_SSHKEYS} ); then
	   for f in ${IMAGE_MPK_ROOT_SSHKEYS}
	   do
	       if ( ! -e ${f} ); then
		       cat ${f} >> ${WORKDIR}/authorized_keys
			   echo "" >> ${WORKDIR}/authorized_keys
		   else
		       bbwarn "ssh_authorized keys \"${f}\" not found...skipped"
		   fi
	   done
	fi
    install -m 644 ${WORKDIR}/authorized_keys ${D}/home/root/.ssh
}

FILES:${PN}:append = " /home/root"
