#! /usr/bin/env nix-shell
#! nix-shell -i bash -p curl jq unzip
# shellcheck shell=bash
set -eu -o pipefail

# Downloaded here:
# https://raw.githubusercontent.com/NixOS/nixpkgs/master/pkgs/applications/editors/vscode/extensions/update_installed_exts.sh
# And then modified in attempt to fix https://github.com/NixOS/nixpkgs/issues/197682
#
# can be added to your configuration with the following command and snippet:
# $ ./pkgs/applications/editors/vscode/extensions/update_installed_exts.sh > extensions.nix
#
# packages = with pkgs;
#   (vscode-with-extensions.override {
#     vscodeExtensions = map
#       (extension: vscode-utils.buildVscodeMarketplaceExtension {
#         mktplcRef = {
#          inherit (extension) name publisher version sha256;
#         };
#       })
#       (import ./extensions.nix).extensions;
#   })
# ]

ARCH="linux-x64"

# Helper to just fail with a message and non-zero exit code.
function fail() {
	echo "$1" >&2
	exit 1
}

# Helper to clean up after ourselves if we're killed by SIGINT.
function clean_up() {
	TDIR="${TMPDIR:-/tmp}"
	echo "Script killed, cleaning up tmpdirs: $TDIR/vscode_exts_*" >&2
	rm -Rf "$TDIR/vscode_exts_*"
}

function get_vsixpkg() {
	N="$1.$2"

	# Create a tempdir for the extension download.
	EXTTMP=$(mktemp -d -t vscode_exts_XXXXXXXX)

	URL=$(curl --silent --show-error --retry 3 --fail -X GET \
		https://marketplace.visualstudio.com/items\?itemName\=$N\&ssr\=false\#version-history |
		grep -Po '(?<=<script class="vss-extension" defer="defer" type="application/json">).*(?=</script>)' |
		jq -r '[.versions[] | select( .targetPlatform as $arch | ["'$ARCH'", null] | index($arch) )][0].files[] | select( .assetType == "Microsoft.VisualStudio.Services.VSIXPackage" ).source')

	# Quietly but delicately curl down the file, blowing up at the first sign of trouble.
	curl --silent --show-error --retry 3 --fail -X GET -o "$EXTTMP/$N.zip" "$URL"

	# LATEST_VERSION=$(curl --silent --show-error --retry 3 --fail -X GET \
	#   https://marketplace.visualstudio.com/items\?itemName\=$N\&ssr\=false\#version-history |
	#   grep -Po "https?://[a-zA-Z0-9./?=_%:-]*/Microsoft.VisualStudio.Services.VSIXPackage" |
	#   sed "s_.*/\([^/]\+\)/[^/]\+/Microsoft.VisualStudio.Services.VSIXPackage_\1_" |
	#   head -n 1)
	# URL="https://$1.gallery.vsassets.io/_apis/public/gallery/publisher/$1/extension/$2/$LATEST_VERSION/assetbyname/Microsoft.VisualStudio.Services.VSIXPackage"
	# echo $URL
	# return

	# PLATFORM_URL=$(jq -r '[.versions[] | select( .targetPlatform == "linux-x64" )][0].files[] | select( .assetType == "Microsoft.VisualStudio.Services.VSIXPackage" ).source')
	# echo $PLATFORM_URL
	# Try download platform specific version first. If failed, try non-platform specific.
	# See https://github.com/NixOS/nixpkgs/issues/197682
	# ARCH_URL="?targetPlatform=$URL"
	# curl --silent --retry 1 --fail -X GET -o "$EXTTMP/$N.zip" "$URL$ARCH_URL" ||
	#   curl --silent --show-error --retry 1 --fail -X GET -o "$EXTTMP/$N.zip" "$URL"

	# Unpack the file we need to stdout then pull out the version
	VER=$(jq -r '.version' <(unzip -qc "$EXTTMP/$N.zip" "extension/package.json"))
	[ -z "$VER" ] && fail "ERROR: failed to validate extensions format!"

	# Calculate the SHA
	SHA=$(nix-hash --flat --base32 --type sha256 "$EXTTMP/$N.zip")

	# Clean up.
	rm -Rf "$EXTTMP"
	# I don't like 'rm -Rf' lurking in my scripts but this seems appropriate.

	cat <<-EOF
		    {
		      name = "$1-$2-$VER";
		      src = {
		        url = "$URL";
		        sha256 = "$SHA";
		        name = "$2-$1.zip";
		      };
		      vscodeExtUniqueId = "$1.$2";
		      vscodeExtPublisher = "$1";
		      vscodeExtName = "$2";
		      version = "$VER";
		    }
	EOF
}

# See if we can find our `code` binary somewhere.
if [ $# -ne 0 ]; then
	CODE=$1
else
	CODE=$(command -v code || command -v codium)
fi

if [ -z "$CODE" ]; then
	# Not much point continuing.
	fail "VSCode executable not found"
fi

# Try to be a good citizen and clean up after ourselves if we're killed.
trap clean_up SIGINT

# Begin the printing of the nix expression that will house the list of extensions.
printf '{ extensions = [\n'

function list_extensions() {
	$CODE --list-extensions
	cat <<EXT
golang.Go
haskell.haskell
vscjava.vscode-spring-initializr
vscjava.vscode-java-pack
vscjava.vscode-gradle
vscodevim.vim
EXT
}

# Note that we are only looking to update extensions that are already installed.
for i in $(list_extensions | grep -v "ms-python.python"); do
	OWNER=$(echo "$i" | cut -d. -f1)
	EXT=$(echo "$i" | cut -d. -f2)

	get_vsixpkg "$OWNER" "$EXT"
done
# Close off the nix expression.
printf '];\n}'
