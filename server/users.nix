{users.mutableUsers = false;

users.users.didier = {
  isNormalUser = true;

  extraGroups = [
    "wheel"
    "docker"
  ];

  openssh.authorizedKeys.keys = [
    "TA_CLE_ED25519"
  ];
};

    users.users.root.hashedPassword = "!";
}
