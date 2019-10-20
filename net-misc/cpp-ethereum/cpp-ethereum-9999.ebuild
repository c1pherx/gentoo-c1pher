# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils multilib git-r3

DESCRIPTION="Ethereum miner with CUDA and stratum support"
HOMEPAGE="https://github.com/ethereum-mining/ethminer"
EGIT_REPO_URI="https://github.com/ethereum-mining/ethminer"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cuda opencl"

RDEPEND="cuda? ( dev-util/nvidia-cuda-toolkit )
	>=dev-cpp/libjson-rpc-cpp-0.4[http-server,http-client,stubgen]
	dev-libs/boost
	>=dev-libs/crypto++-5.6.2
	dev-libs/jsoncpp
	dev-libs/libcpuid
	virtual/opencl"
DEPEND="${RDEPEND}
	dev-libs/gmp
	dev-libs/leveldb
	net-libs/miniupnpc
	net-misc/curl
	sys-libs/readline"

#PATCHES="${FILESDIR}/EthCompilerSettings.cmake.patch"

src_configure() {
	local mycmakeargs=(
		-DBUNDLE="$(usex cuda cudaminer miner)"
		-DETHASHCL="$(usex opencl ON OFF)"
	)

	sed -i -e 's/DESTINATION lib/DESTINATION '$(get_libdir)'/g' libdevcore/CMakeLists.txt || die
	sed -i -e 's/DESTINATION lib/DESTINATION '$(get_libdir)'/g' libethash-cl/CMakeLists.txt || die
	sed -i -e 's/DESTINATION lib/DESTINATION '$(get_libdir)'/g' libethash/CMakeLists.txt || die
	sed -i -e 's/DESTINATION lib/DESTINATION '$(get_libdir)'/g' libethash-cuda/CMakeLists.txt || die
	sed -i -e 's/DESTINATION lib/DESTINATION '$(get_libdir)'/g' libethcore/CMakeLists.txt || die
	sed -i -e 's/DESTINATION lib/DESTINATION '$(get_libdir)'/g' libstratum/CMakeLists.txt || die

	cmake-utils_src_configure
}
