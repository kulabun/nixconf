#!/usr/bin/env bash

function gr() {
	cvm "\$( (test -f \"./gradlew\" && echo \"./gradlew\") || echo \"/usr/bin/env gradle\" )" $@
}

gr "$@"
