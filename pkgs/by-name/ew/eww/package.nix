{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  pkg-config,
  wrapGAppsHook3,
  gtk3,
  librsvg,
  gtk-layer-shell,
  stdenv,
  libdbusmenu-gtk3,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "eww";
  version = "0.6.0-unstable-2025-06-17";

  src = fetchFromGitHub {
    owner = "elkowar";
    repo = "eww";
    rev = "0e409d4a52bd3d37d0aa0ad4e2d7f3b9a8adcdb7";
    hash = "sha256-QGs9H+SBoMjvznTh3RZVjlwQPkcz6S6CbxC71cS49dk=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-SEdr9nW5nBm1g6fjC5fZhqPbHQ7H6Kk0RL1V6OEQRdA=";

  nativeBuildInputs = [
    installShellFiles
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    gtk3
    gtk-layer-shell
    libdbusmenu-gtk3
    librsvg
  ];

  cargoBuildFlags = [
    "--bin"
    "eww"
  ];

  cargoTestFlags = cargoBuildFlags;

  # requires unstable rust features
  RUSTC_BOOTSTRAP = 1;

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd eww \
      --bash <($out/bin/eww shell-completions --shell bash) \
      --fish <($out/bin/eww shell-completions --shell fish) \
      --zsh <($out/bin/eww shell-completions --shell zsh)
  '';

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Widget system made in Rust to create widgets for any WM";
    longDescription = ''
      Eww (ElKowar's Wacky Widgets) is a widget system made in Rust which lets
      you create your own widgets similarly to how you can in AwesomeWM.
      The key difference: It is independent of your window manager!
      It can be configured in yuck and themed using CSS, is very easy
      to customize and provides all the flexibility you need!
    '';
    homepage = "https://github.com/elkowar/eww";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      coffeeispower
      figsoda
      lom
      w-lfchen
    ];
    mainProgram = "eww";
    broken = stdenv.hostPlatform.isDarwin;
  };
}
