compile:
	@mkdir bin 2>/dev/null
	./scripts/pingpong_compile.sh

package_ping:
	./scripts/ping_package.sh

package_pong:
	./scripts/pong_package.sh
