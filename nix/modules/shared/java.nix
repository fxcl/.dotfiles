{ pkgs, lib, config, options, ... }:

let
  cfg = config.my.modules.java;

in

{
  options = with lib; {
    my.modules.java = {
      enable = mkEnableOption ''
        Whether to enable java module
      '';
    };
  };

  config = with lib;
    mkIf cfg.enable {
      my.user = {
        packages = with pkgs; [
          jdk21
          (maven.override {jdk = pkgs.jdk21;})
          # gradle
          java-language-server
          # vagrant
        ];
      };

      my.hm.file = {
        ".m2/settings.xml" = {
          target = ".m2/settings.xml";
          text = ''
            <?xml version="1.0" encoding="UTF-8"?>
            <settings xmlns="http://maven.apache.org/SETTINGS/1.0.0"
                      xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                      xsi:schemaLocation="http://maven.apache.org/SETTINGS/1.0.0 http://maven.apache.org/xsd/settings-1.0.0.xsd">
              <pluginGroups>
              </pluginGroups>
              <proxies>
              </proxies>
              <servers>
                <server>
                  <id>central</id>
                  <username>kV9niWOQ</username>
                  <password>/yOrDA/2ZFqq7q0kUiABepa5FHhMPekOoso2V4rmRXzz</password>
                </server>
              </servers>
                <mirrors>
                  <mirror>
                	<id>alimaven</id>
                	<mirrorOf>central</mirrorOf>
                	<name>aliyun maven</name>
                	<url>http://maven.aliyun.com/nexus/content/repositories/central/</url>
                </mirror>
                <!-- junit镜像地址 -->
                <mirror>
                	<id>junit</id>
                	<name>junit Address/</name>
                	<url>http://jcenter.bintray.com/</url>
                	<mirrorOf>central</mirrorOf>
                </mirror>
                <mirror>
                    <id>aliyunmaven</id>
                    <mirrorOf>*</mirrorOf>
                    <name>阿里云公共仓库</name>
                    <url>https://maven.aliyun.com/repository/public</url>
                </mirror>
                <mirror>
                    <id>huaweicloud</id>
                    <mirrorOf>*</mirrorOf>
                    <name>HuaweiCloud Maven Mirror</name>
                    <url>https://repo.huaweicloud.com/repository/maven/</url>
                </mirror>
                <mirror>
                    <id>nexus-tencentyun</id>
                    <mirrorOf>*</mirrorOf>
                    <name>Nexus tencentyun</name>
                    <url>http://mirrors.cloud.tencent.com/nexus/repository/maven-public/</url>
                </mirror>
                <mirror>
                    <id>nexus-163</id>
                    <mirrorOf>*</mirrorOf>
                    <name>Nexus 163</name>
                    <url>http://mirrors.163.com/maven/repository/maven-public/</url>
                </mirror>
              </mirrors>
              <profiles>
                <profile>
                  <id>central</id>
                  <activation>
                    <activeByDefault>true</activeByDefault>
                  </activation>
                  <properties>
                    <!-- gpg.exe 文件的位置 -->
                    <gpg.executable>gpg</gpg.executable>
                    <!-- 创建密钥对时配置的密码 -->
                    <gpg.passphrase>11117777</gpg.passphrase>
                  </properties>
                </profile>
              </profiles>
            </settings>
          '';
        };

        ".m2/toolchains.xml" = {
          target = ".m2/toolchains.xml";
          text = ''
            <?xml version="1.0" encoding="UTF-8"?>
            <toolchains>
              <!-- JDK toolchains -->
              <toolchain>
                <type>jdk</type>
                <provides>
                  <version>8</version>
                </provides>
                <configuration>
                  <jdkHome>${pkgs.jdk21}/lib/openjdk</jdkHome>
                </configuration>
              </toolchain>
            </toolchains>
          '';
        };

      };

      environment = {
        systemPackages = [
        ];
        shellInit = ''
          test -e ${pkgs.jdk21}/nix-support/setup-hook && source ${pkgs.jdk21}/nix-support/setup-hook
        '';
        variables = {
          LANG = "en_US.UTF-8";
          LC_TIME = "en_GB.UTF-8";
          JAVA_HOME = ''${pkgs.jdk21.home}'';
          JAVA_CPPFLAGS = ''-I${pkgs.jdk21}/include/'';
          MAVEN_OPTS = "-Djava.awt.headless=true -Dorg.slf4j.simpleLogger.showDateTime=true -Dorg.slf4j.simpleLogger.dateTimeFormat=HH:mm:ss,SSS";
        };
      };
    };
}
