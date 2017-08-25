# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGO_PN="camlistore.org/camlistore"
EGIT_COMMIT="8f1a7df176de21d0d052c04db45b373c5c282fb1"
# May want to vendor dependencies later.
EGO_VENDOR=()

inherit golang-vcs-snapshot golang-build

DESCRIPTION="Content-Addressable Multi-Layer Indexed Storage"
HOMEPAGE="https://camlistore.org"
SRC_URI="https://github.com/${PN}/${PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz
${EGO_VENDOR_URI}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_compile() {
	# Specify version so it doesn't try to use the git revision (no .git)
	echo "${PV}" >> "${WORKDIR}/${P}/src/${EGO_PN}/VERSION"
	pushd "${WORKDIR}/${P}/src/${EGO_PN}" > /dev/null
	set -- env GOPATH="${WORKDIR}/${P}:$(get_golibdir_gopath)" \
		go run -v -work "${WORKDIR}/${P}/src/${EGO_PN}/make.go"
	echo "$@"
	"$@" || die
	popd > /dev/null
}

src_install() {
	pushd "${WORKDIR}/${P}/src/${EGO_PN}" > /dev/null
	local binaries=("camdeploy" "camget" "camlistored" "cammount" \
		            "cammount" "camput" "camtool" "publisher" \
					"scancab" "scanningcabinet")
	for bin in "${binaries[@]}"; do
		dobin bin/"${bin}"
	done

	dodoc README
	popd > /dev/null
}
