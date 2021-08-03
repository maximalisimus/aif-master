pkgname=aif-master
_pkgrun="aif"
pkgver=2.6
pkgrel=1
arch=('any')
url="https://github.com/maximalisimus/$pkgname/"
license=('GPL')
depends=(dialog parted arch-install-scripts git)
makedepends=(git imagemagick)
replaces=($pkgname)

source=("$pkgname::git+https://github.com/maximalisimus/$pkgname.git"
	)
	
md5sums=('SKIP'
	)

prepare() {
	cd ${srcdir}/$pkgname
	mkdir -p ./post/
	make DESTDIR=./post/ all
	make DESTDIR=./post/ install
}

package() {
	mkdir -p $pkgdir/usr/
	cp -a ${srcdir}/$pkgname/post/usr/* $pkgdir/usr/
}
