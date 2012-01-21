# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ada/gps-bin/gps-bin-2.1.0.ebuild,v 1.5 2009/09/23 16:28:37 patrick Exp $

IUSE=""

S="${WORKDIR}/gps-${PV}-academic-x86-linux"
DESCRIPTION="GNAT Programming System"
SRC_URI="http://libre.act-europe.fr/gps/gps-${PV}-academic-x86-linux.tgz"
HOMEPAGE="http://libre.act-europe.fr/gps"

KEYWORDS="~amd64 ~x86"
LICENSE="GPL-2"
SLOT="0"

DEPEND=""
NATIVE_DEPS="virtual/gnat
	>=x11-libs/gtk+-2.2.0
	>=dev-ada/gtkada-2.4.0
	>=media-libs/libpng-1.2.4"

EMUL_DEPS="app-emulation/emul-linux-x86-baselibs
	app-emulation/emul-linux-x86-gtklibs
	app-emulation/emul-linux-x86-compat
	app-emulation/emul-linux-x86-xlibs"

RDEPEND="x86? ( $NATIVE_DEPS )
	amd64? ( $EMUL_DEPS )"

src_compile() {
	einfo "nothing to be done"
}

src_install () {
	#for some reason doins strips exec privs on all binaries here, use mv instead
	dodir /opt/${PN}
	mv bin lib share ${D}/opt/${PN}/

	# Install documentation.
	dodoc README
	doinfo doc/gps/info/*
	mv doc/gps/{examples,html,ps,txt} ${D}/usr/share/doc/${PF}

	#gps was compiled against libpng.so.2 which in fact is libpng.so.3 on gentoo systems
	if use amd64; then
		dosym /usr/lib32/libpng.so /opt/${PN}/lib/libpng.so.2
	else
		dosym /usr/lib/libpng.so /opt/${PN}/lib/libpng.so.2
		sed -i -e "s|:/usr/lib32||" ${FILESDIR}/10gps-bin
	fi

	#now some env vars
	doenvd ${FILESDIR}/10gps-bin
	echo "GPS_DOC_PATH=/usr/share/doc/${PF}/html" >> ${D}/etc/env.d/10gps-bin
}

pkg_postinst(){
	elog "This is GNAT Programming System, enjoy!"
	elog "Please note, if you plan on using gtkada, beware that while compiling
	your app from within gps, it will link against its own libraries
	instead of the system-wide gtkada library!"
}
