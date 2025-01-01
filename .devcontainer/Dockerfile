FROM mcr.microsoft.com/devcontainers/base:bookworm
RUN install --directory \
    --owner=vscode \
    --group=vscode \
    /nix \
    /workspace

USER vscode
COPY assets/etc/ /etc
RUN curl -sSL 'https://nixos.org/nix/install' \
    | sh -s -- \
    --no-daemon \
    --yes

ARG NIX_LINK="/home/vscode/.nix-profile"
ENV NIX_PROFILES="/nix/var/nix/profiles/default ${NIX_LINK}" \
    XDG_DATA_DIRS="/usr/local/share:/usr/share:${NIX_LINK}/share:/nix/var/nix/profiles/default/share" \
    NIX_SSL_CERT_FILE="/etc/ssl/certs/ca-certificates.crt" \
    MANPATH="${NIX_LINK}/share/man:$MANPATH" \
    PATH="${NIX_LINK}/bin:$PATH"

COPY --chown=vscode:vscode \
    flake.nix \
    flake.lock \
    shell.nix \
    /opt/nix-env/
COPY --chown=vscode:vscode assets/home/vscode/ /home/vscode/
RUN cd /opt/nix-env \
    && git init --quiet --initial-branch=main \
    && git config user.email "system@localhost" \
    && git config user.name "system" \
    && git add . \
    && git commit -a -m"chore: flakes ready" \
    && mkdir ~/.cache/starship \
    && nix profile install
# && nix develop -c nu -c 'starship init nu | save -f ~/.cache/starship/init.nu'
# RUN chmod 0700 /home/vscode/.local/init_clone.sh

# WORKDIR /workspace
# CMD [ "nix", "develop", "/opt/nix-env", "--command", "nu" ]
