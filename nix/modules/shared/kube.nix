{ pkgs, lib, config, options, ... }:

let
  cfg = config.my.modules.kube;

in

{
  options = with lib; {
    my.modules.kube = {
      enable = mkEnableOption ''
        Whether to enable kube module
      '';
    };
  };

  config = with lib;
    mkIf cfg.enable {
      environment = {
        systemPackages = with pkgs; [
          # helm # The package manage
          # helm-docs # A tool for automatically generating markdown documentation for helm charts
          argocd #Declarative continuous deployment for Kubernetes.
          jsonnet
          jsonnet-bundler # A jsonnet package manager.
          k9s # Kubernetes CLI To Manage Your Clusters In Style!
          krew # Krew is the plugin manager for kubectl command-line tool.
          kubectl
          kustomize # Customization of kubernetes YAML configurations
          kustomize-sops # KSOPS - A Flexible Kustomize Plugin for SOPS Encrypted Resources
          stern # Multi pod and container log tailing for Kubernetes
        ];
      };
    };
}
