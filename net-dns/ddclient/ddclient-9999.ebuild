# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

if [[ "${PV}" != "9999" ]]; then
	SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
else
	EGIT_REPO_URI="git://git.code.sf.net/p/ddclient/git"
	inherit git-2
fi

inherit systemd user

if [[ "${PV}" == "9999" ]]; then
	KEYWORDS=""
else
	KEYWORDS="~amd64 ~x86"
fi


DESCRIPTION="Perl updater client for dynamic DNS services"
HOMEPAGE="http://ddclient.sourceforge.net/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="cloudflare hardened"

RDEPEND=">=dev-lang/perl-5.1
	virtual/perl-Digest-SHA
	dev-perl/IO-Socket-SSL
	dev-perl/Data-Validate-IP
	cloudflare? ( dev-perl/JSON-Any )
	hardened? ( sys-apps/iproute2 )
"

pkg_setup() {
	enewgroup ${PN}
	enewuser ${PN} -1 -1 -1 ${PN}
}

src_prepare() {
	default

	# Remove pid setting because we can't leave it user configurable and
	# reliably setup the environment for the init script to stop ${PN}
	ebegin "Removing PID setting from ${PN}.conf"
	sed '/^pid/d' -i "sample-etc_${PN}.conf" || die
	eend $?
}

src_install() {
	dosbin ${PN}
	dodoc Change* COPYRIGHT README* RELEASENOTE sample*

	newinitd "${FILESDIR}/${PN}.initd-r4" ${PN}
	systemd_dounit "${FILESDIR}"/${PN}.service

	insopts -m 0600 -o ${PN} -g ${PN}
	insinto /etc/${PN}
	newins sample-etc_${PN}.conf ${PN}.conf
	newins sample-etc_${PN}.conf ${PN}.conf.sample
}
