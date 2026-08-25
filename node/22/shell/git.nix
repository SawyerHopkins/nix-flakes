{
  writeShellApplication,
  git,
  openssh,
  userName,
  userEmail
}:
writeShellApplication {
  name = "setup-git";
  runtimeInputs = [ git openssh ];
  text = ''
    mkdir -p /root/.ssh
    git config --global user.name  "${userName}"
    git config --global user.email "${userEmail}"

    ssh-add -L > /root/.ssh/signing.pub
    printf '%s namespaces="git" %s\n' \
      "${userEmail}" "$(cat /root/.ssh/signing.pub)" > /root/.ssh/allowed_signers

    git config --global gpg.format ssh
    git config --global gpg.ssh.program "${openssh}/bin/ssh-keygen"
    git config --global gpg.ssh.allowedSignersFile /root/.ssh/allowed_signers
    git config --global user.signingkey /root/.ssh/signing.pub
    git config --global commit.gpgsign true
    git config --global tag.gpgsign true
  '';
}
