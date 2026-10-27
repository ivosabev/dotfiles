#!/usr/bin/env bats

setup() {
	WORK=$(mktemp -d)
	LOG="$WORK/log"
	mkdir -p "$WORK/bin"
	cat > "$WORK/bin/cursor-agent" <<'EOF'
#!/usr/bin/env bash
printf '%s\n' "$1" >> "$LOG"
case "$1" in
	update)
		n=$(grep -c '^update$' "$LOG")
		case "${CURSOR_AGENT_MODE}" in
			ok)
				echo "Already up to date"
				exit 0
				;;
			other)
				echo "network down" >&2
				exit 2
				;;
			then-ok)
				if [[ "$n" -ge 2 ]]; then
					echo "Already up to date"
					exit 0
				fi
				;;
		esac
		echo "Checking for updates..."
		echo "Error: Update failed: [unauthenticated] Error" >&2
		exit 1
		;;
	login)
		if [[ "${CURSOR_AGENT_MODE}" == "login-fail" ]]; then
			exit 1
		fi
		echo "login-ui"
		exit 0
		;;
esac
exit 3
EOF
	chmod +x "$WORK/bin/cursor-agent"
	export PATH="$WORK/bin:$PATH"
	export LOG
	SCRIPT="$(cd "$BATS_TEST_DIRNAME/../bin" && pwd)/cursor-agent-update"
}

teardown() {
	rm -rf "$WORK"
}

@test "prints a successful update and does not ask" {
	export CURSOR_AGENT_MODE=ok
	run "$SCRIPT"
	[ "$status" -eq 0 ]
	[[ "$output" == *"Already up to date"* ]]
	[[ "$output" != *"Log in now?"* ]]
	[ "$(cat "$LOG")" = "update" ]
}

@test "keeps a non-auth update failure" {
	export CURSOR_AGENT_MODE=other
	run "$SCRIPT"
	[ "$status" -eq 2 ]
	[[ "$output" == *"network down"* ]]
	[[ "$output" != *"Log in now?"* ]]
}

@test "does not block when login expired and there is no terminal" {
	export CURSOR_AGENT_MODE=unauthenticated
	run "$SCRIPT" </dev/null
	[ "$status" -eq 0 ]
	[[ "$output" == *"Cursor Agent login expired."* ]]
	[[ "$output" == *"cursor-agent login"* ]]
	[[ "$output" != *"Log in now?"* ]]
	[ "$(cat "$LOG")" = "update" ]
}

answer() {
	CURSOR_AGENT_MODE="$1" ANSWER="$2" SCRIPT="$SCRIPT" LOG="$LOG" python3 - <<'PY'
import os, pty, select, subprocess, time
master, slave = pty.openpty()
proc = subprocess.Popen(
    [os.environ["SCRIPT"]],
    stdin=slave,
    stdout=slave,
    stderr=slave,
    close_fds=True,
)
os.close(slave)
wanted = os.environ["ANSWER"].encode()
sent = False
out = b""
deadline = time.time() + 10
while time.time() < deadline:
    ready, _, _ = select.select([master], [], [], 0.2)
    if master in ready:
        try:
            chunk = os.read(master, 4096)
        except OSError:
            break
        if not chunk:
            break
        out += chunk
        if not sent and b"Log in now?" in out:
            os.write(master, wanted)
            sent = True
    elif proc.poll() is not None:
        break
proc.wait(timeout=5)
os.close(master)
text = out.decode("utf-8", "replace")
print(text)
if not sent:
    raise SystemExit("prompt was not shown")
raise SystemExit(proc.returncode)
PY
}

@test "skips the update when login is declined" {
	run answer unauthenticated $'n\n'
	[ "$status" -eq 0 ]
	[[ "$output" == *"Log in now?"* ]]
	[[ "$output" == *"Skipped Cursor Agent update."* ]]
	[ "$(cat "$LOG")" = "update" ]
}

@test "logs in and updates when the answer is yes" {
	run answer then-ok $'y\n'
	[ "$status" -eq 0 ]
	[[ "$output" == *"login-ui"* ]]
	[[ "$output" == *"Already up to date"* ]]
	[ "$(cat "$LOG")" = $'update\nlogin\nupdate' ]
}

@test "continues when login does not finish" {
	run answer login-fail $'yes\n'
	[ "$status" -eq 0 ]
	[[ "$output" == *"Cursor Agent login did not finish."* ]]
	[ "$(cat "$LOG")" = $'update\nlogin' ]
}
