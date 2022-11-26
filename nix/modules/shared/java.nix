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
          graalvm17-ce
          maven
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
              </profiles>
            </settings>
          '';
        };
      };

      environment = {
        systemPackages = [
          pkgs.intellij-idea-ce
        ];
        shellInit = ''
          test -e ${pkgs.graalvm17-ce}/nix-support/setup-hook && source ${pkgs.graalvm17-ce}/nix-support/setup-hook
        '';
        variables = {
          LANG = "en_US.UTF-8";
          LC_TIME = "en_GB.UTF-8";
          JAVA_HOME = ''${pkgs.graalvm17-ce.home}'';
          JAVA_CPPFLAGS = ''-I${pkgs.graalvm17-ce}/include/'';
          MAVEN_OPTS = "-Djava.awt.headless=true -Dorg.slf4j.simpleLogger.showDateTime=true -Dorg.slf4j.simpleLogger.dateTimeFormat=HH:mm:ss,SSS";
        };
      };
    };
}
