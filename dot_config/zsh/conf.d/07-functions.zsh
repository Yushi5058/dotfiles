# 07-functions.zsh — Custom functions

# Create a new Java Maven project folder instantly
makejava() {
    mkdir -p "$1/src/main/java/com/school"
    cat <<EOF > "$1/pom.xml"
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/maven-v4_0_0.xsd">
  <modelVersion>4.0.0</modelVersion>
  <groupId>com.school</groupId>
  <artifactId>$1</artifactId>
  <version>1.0-SNAPSHOT</version>
  <properties>
    <maven.compiler.source>17</maven.compiler.source>
    <maven.compiler.target>17</maven.compiler.target>
  </properties>
</project>
EOF
    echo "Project $1 created! Code goes in $1/src/main/java/com/school"
}

# Enable zmv
autoload -Uz zmv