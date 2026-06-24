# Homebrew OpenJDK 17 — system-wide default (overrides sdkman after init)
export JAVA_HOME="$(brew --prefix openjdk@17)/libexec/openjdk.jdk/Contents/Home"
export PATH="$JAVA_HOME/bin:$PATH"
