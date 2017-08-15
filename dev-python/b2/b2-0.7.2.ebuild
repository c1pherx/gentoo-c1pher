# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5,6} )
inherit distutils-r1

DESCRIPTION="Command line tool for Backblaze B2"
HOMEPAGE="https://pypi.python.org/pypi/b2/0.7.2"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	dev-python/nose
	dev-python/pyflakes
	dev-python/six
	dev-python/yapf"

RESTRICT="test"

python_prepare_all() {
	local PATCHES=(
		"${FILESDIR}/${P}-setup-tests.patch"
	)
	distutils-r1_python_prepare_all
}
