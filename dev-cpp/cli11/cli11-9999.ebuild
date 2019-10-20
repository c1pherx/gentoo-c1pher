# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils git-r3

DESCRIPTION="A command line parser for C++11 and beyond that provides a rich feature set with a simple and intuitive interface."
HOMEPAGE="https://github.com/cliutils/cli11"
EGIT_REPO_URI="https://github.com/cliutils/${PN}.git"

if [[ ${PV} == 9999 ]]; then
	KEYWORDS=""
else
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="BSD-with-attribution"
SLOT="0"
IUSE="doc test"

RDEPEND=""
DEPEND="${RDEPEND}
"

CMAKE_MIN_VERSION="2.8"

src_unpack() {
	git-r3_src_unpack
}

src_prepare() {
	cmake-utils_src_prepare
}

src_configure() {
	cmake-utils_src_configure
}
