self: super:

{
  # anyconfig = super.callPackage ./anyconfig {};
  # ansible-later = super.callPackage ./ansible-later {};
  dockutil = super.callPackage ./dockutil { };
  mysides = super.callPackage ./mysides { };
  intellij-idea-ce = super.callPackage ./intellij { };
  firefox-mac = super.callPackage ./firefox { };
  speedtest = super.callPackage ./speedtest-cli {};
}
