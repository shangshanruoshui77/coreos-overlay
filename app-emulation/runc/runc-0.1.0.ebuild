# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

GITHUB_URI="github.com/opencontainers/runc"
COREOS_GO_PACKAGE="${GITHUB_URI}"
COREOS_GO_VERSION="go1.6"

inherit eutils multilib coreos-go-depend

DESCRIPTION="runc container cli tools"
HOMEPAGE="http://runc.io"

if [[ ${PV} == *9999* ]]; then
	EGIT_REPO_URI="git://${GITHUB_URI}.git"
	inherit git-r3
else
	SRC_URI="https://${GITHUB_URI}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 arm64"
fi

LICENSE="Apache-2.0"
SLOT="0"
IUSE="+seccomp"

DEPEND=">=dev-lang/go-1.4:="
RDEPEND="seccomp? ( sys-libs/libseccomp )"

src_compile() {
	# Setup GOPATH so things build
	rm -rf .gopath
	mkdir -p .gopath/src/"$(dirname "${GITHUB_URI}")"
	ln -sf ../../../.. .gopath/src/"${GITHUB_URI}"
	export GOPATH="${PWD}/.gopath:${PWD}/vendor"

	# build up optional flags
	local options=( $(usex seccomp "seccomp") )

	emake BUILDTAGS="${options[@]}"
}

src_install() {
	dobin runc
}