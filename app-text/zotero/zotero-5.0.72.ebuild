# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

# Forked from https://github.com/xdch47/gpo-xdch47

EAPI=6

inherit xdg-utils gnome2-utils

DESCRIPTION="Helps you collect, organize, cite, and share your research sources."
HOMEPAGE="http://www.zotero.org/download"

if [[ $ARCH == "amd64" ]]; then
	_arch=x86_64
elif [[ $ARCH == "x86" ]]; then
	_arch=i686
fi

SRC_URI="https://www.zotero.org/download/client/dl?channel=release&platform=linux-${_arch}&version=${PV} -> ${P}.tar.bz2"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-libs/dbus-glib
		media-libs/alsa-lib
		>=x11-libs/gtk+-2:*
		dev-libs/nss"
RDEPEND="${DEPEND}"

S=${WORKDIR}/Zotero_linux-${_arch}

ZOTERODIR=/opt/zotero

src_prepare() {
	# disable update
	pref_zotero=defaults/preferences/prefs.js
	sed -i -e 's/\(pref("app.update.enabled"\).*/\1, false);/' ${pref_zotero}

	# disable default oo installation questions - manual installation is still possible
	pref_zOOI=extensions/zoteroOpenOfficeIntegration@zotero.org/defaults/preferences/zoteroOpenOfficeIntegration.js
	sed -i -e 's/\(pref("extensions.zoteroOpenOfficeIntegration.skipInstallation"\).*/\1, true);/' ${pref_zOOI}

	# fix desktop-file
	sed -i -e "s#^Exec=.*#Exec=${ZOTERODIR}/zotero#" zotero.desktop
	sed -i -e "s#Icon=zotero.*#Icon=zotero#" zotero.desktop

	eapply_user
}

src_install() {
	insinto ${ZOTERODIR}
	for f in * ; do
		cp -r $f "${ED%/}"/${ZOTERODIR}
	done

	# xdg desktop
	insinto /usr/share/applications
	doins zotero.desktop

	# Copy zotero icons to a standard location
	for is in 16 32 48; do
		insinto /usr/share/icons/hicolor/${is}x${is}/apps
		newins chrome/icons/default/default${is}.png zotero.png
	done
	dodir /usr/share/pixmaps
	dosym  ../icons/hicolor/48x48/apps/zotero.png /usr/share/pixmaps/zotero.png
}

pkg_postinst() {
	xdg_desktop_database_update
	gnome2_icon_cache_update
}

pkg_postrm() {
	xdg_desktop_database_update
	gnome2_icon_cache_update
}
