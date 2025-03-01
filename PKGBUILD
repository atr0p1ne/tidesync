# tidesync/PKGBUILD

# Maintainer info
pkgname=tidesync
pkgver=1.0.0
pkgrel=1
pkgdesc="Syncing directories across devices. Written in Fish"
arch=('any')
url="https://github.com/atr0p1ne/tidesync"
license=('GPL3')
depends=('rsync' 'fish')
source=("git+https://github.com/atr0p1ne/tidesync.git")
sha256sums=('SKIP') # Use 'SKIP' if you’re testing or generating from GitHub

# Prepare the package
prepare() {
  cd "$srcdir"
  # No preparation needed, unless you need to patch or modify the source
}

# Build the package
build() {
  cd "$srcdir"
  # No build steps needed since it's a Fish shell module
}

# Install the package
package() {
  cd "$srcdir"
  mkdir -p "$pkgdir/usr/share/tidesync"
  mkdir -p "$pkgdir/usr/share/fish/functions"
  
  cp -r "$srcdir/usr/share/tidesync/*" "$pkgdir/usr/share/tidesync/*"
  cp "$srcdir/usr/share/fish/functions/tidesync.fish" "$pkgdir/usr/share/fish/functions/tidesync.fish"
 
}

# Optional: Clean up unnecessary files
clean() {
  rm -rf "$srcdir"/.git
}
