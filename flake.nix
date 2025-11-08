{
  description = "Mansoor Faqiri's NixOS flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs?ref=nixos-25.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager-stable = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    hyprland.url = "github:hyprwm/Hyprland";
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.3";

      # Optional but recommended to limit the size of your system closure.
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix.url = "github:Mic92/sops-nix";

    nvf.url = "github:notashelf/nvf";

    nix-darwin.url = "github:nix-darwin/nix-darwin/nix-darwin-25.05";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs-stable";
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";

    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };

    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };

    homebrew-mssql = {
      url = "github:Microsoft/homebrew-mssql-release";
      flake = false;
    };
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-stable,
    nix-darwin,
    ...
  } @ inputs: let
    system = "x86_64-linux";
  in {
    nixosConfigurations = {
      desktop = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit system;
          inherit inputs;
          secretsPath = ./secrets;
        };

        modules = [
          ./nixos/desktop-host/configuration.nix
          inputs.lanzaboote.nixosModules.lanzaboote
          inputs.home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "bak";
          }
          inputs.sops-nix.nixosModules.sops
        ];
      };

      laptop = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit system;
          inherit inputs;
        };

        modules = [
          ./nixos/laptop-host/configuration.nix
          inputs.home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.yourusername = import ./users/yourusername.nix;

            # Pass inputs to Home Manager
            home-manager.extraSpecialArgs = {
              inherit inputs;
            };
          }
        ];
      };
    };

    darwinConfigurations = {
      work-mac = nix-darwin.lib.darwinSystem {
        specialArgs = {
          inherit inputs;
        };
        modules = [
          ./nixos/darwin-host/configuration.nix
          inputs.nvf.nixosModules.default
          inputs.nix-homebrew.darwinModules.nix-homebrew
          {
            nix-homebrew = {
              # Install Homebrew under the default prefix
              enable = true;

              # User owning the Homebrew prefix
              user = "mfaqiri";

              autoMigrate = true;

              # Optional: Declarative tap management
              taps = {
                "homebrew/homebrew-core" = inputs.homebrew-core;
                "homebrew/homebrew-cask" = inputs.homebrew-cask;
                "Microsoft/homebrew-mssql-release" = inputs.homebrew-mssql;
              };

              # Optional: Enable fully-declarative tap management
              #
              # With mutableTaps disabled, taps can no longer be added imperatively with `brew tap`.
              mutableTaps = true;
            };
          }
          inputs.home-manager-stable.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            home-manager.users.mfaqiri = {
              config,
              pkgs,
              lib,
              ...
            }: {
              imports = [./home-manager/kitty.nix];
              home = {
                stateVersion = "25.05";
                username = "mfaqiri";
                homeDirectory = lib.mkForce "/Users/mfaqiri";
                file.".gitconfig-godaddy".text = ''
                  [user]
                    email = mfaqiri@godaddy.com
                '';
              };
              fonts.fontconfig.enable = true;

              programs = {
                git = {
                  enable = true;
                  userName = "Mansoor Faqiri";
                  userEmail = "mzfaqiri@gmail.com";

                  extraConfig = {
                    core = {
                      editor = "nvim";
                    };
                    init = {
                      defaultBranch = "main";
                    };
                    pull = {
                      rebase = false;
                    };
                    # This ensures includeIf comes at the end
                  };

                  includes = [
                    {
                      condition = "gitdir:~/projects/GoDaddy/";
                      path = "~/.gitconfig-godaddy";
                    }
                  ];
                  # Git aliases (optional)
                  aliases = {
                    st = "status";
                    co = "checkout";
                    br = "branch";
                    ci = "commit";
                    unstage = "reset HEAD --";
                  };
                };
                ssh = {
                  enable = true;

                  matchBlocks = {
                    # Personal GitHub account
                    "github.com" = {
                      hostname = "github.com";
                      user = "git";
                      identityFile = "~/.ssh/id_ed25519_personal";
                      extraOptions = {
                        AddKeysToAgent = "yes";
                        UseKeychain = "yes";
                      };
                    };

                    # Work GitHub account
                    "github.com-godaddy" = {
                      hostname = "github.com";
                      user = "git";
                      identityFile = "~/.ssh/id_ed25519_godaddy";
                      extraOptions = {
                        AddKeysToAgent = "yes";
                        UseKeychain = "yes";
                      };
                    };
                  };
                };
                home-manager.enable = true;
                zsh = {
                  enable = true;
                  enableCompletion = true;
                  syntaxHighlighting.enable = true;

                  shellAliases = {
                    ll = "ls -l";
                    sed = "gsed";
                    update = "sudo HOMEBREW_ACCEPT_EULA=YES darwin-rebuild switch --flake /Users/mfaqiri/.config/nix#work-mac";
                  };

                  initContent =
                    /*
                    bash
                    */
                    ''
                      export DOCKER_HOST=unix:///Users/$USER/.colima/docker.sock
                      export TERM=xterm-256color
                      eval "$(direnv hook zsh)"
                      # Source any other private zsh config
                      if [[ -f ~/.zshrc.private ]]; then
                        source ~/.zshrc.private
                      fi
                    '';

                  zplug = {
                    enable = true;
                    plugins = [
                      {name = "zsh-users/zsh-autosuggestions";}
                      {
                        name = "ergenekonyigit/lambda-gitster";
                        tags = ["as:theme"];
                      }
                      {name = "chisui/zsh-nix-shell";}
                    ];
                  };

                  history.size = 10000;
                  history.ignoreAllDups = true;
                  history.path = "$HOME/.zsh_history";
                };

                yazi = {
                  enable = true;
                  enableZshIntegration = true;
                };

                zoxide = {
                  enable = true;
                  enableZshIntegration = true;
                  options = ["--cmd cd"];
                };
              };
            };
          }
        ];
      };
    };
  };
}
