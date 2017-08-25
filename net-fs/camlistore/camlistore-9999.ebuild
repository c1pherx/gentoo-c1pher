# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGO_PN="camlistore.org/camlistore"
# May want to vendor dependencies later.

if [[ ${PV} == *9999* ]]; then
	# Don't use golang-vcs. Requires a buildable package and we don't
	# have that due to camlistore's build system.
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}/src/${EGO_PN}"
	EGIT_REPO_URI="https://${PN}.googlesource.com/${PN}"
	inherit git-r3
else
	EGO_VENDOR=()
	KEYWORDS="~amd64 ~x86"
	EGIT_COMMIT="8f1a7df176de21d0d052c04db45b373c5c282fb1"
	SRC_URI="https://github.com/${PN}/${PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz
${EGO_VENDOR_URI}"
	inherit golang-vcs-snapshot
fi

inherit golang-build

DESCRIPTION="Content-Addressable Multi-Layer Indexed Storage"
HOMEPAGE="https://camlistore.org"

LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_compile() {
	if [[ ${PV} != *9999* ]]; then
		# Specify version so it doesn't try to use the git revision (no .git)
		echo "${PV}" >> "${WORKDIR}/${P}/src/${EGO_PN}/VERSION"
	fi
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
