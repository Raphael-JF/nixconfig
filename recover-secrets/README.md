# SOPS Secrets Recovery

In the unfortunate event that I lose all my machines, I've set up a last-resort recovery method for my SOPS secrets.
The `recovery-key.txt.age` file contains an Age recovery key encrypted with a passphrase known only to me. This key allows me to recover all the secrets stored in my NixOS configuration.

## Decrypt the recovery key

```bash
age -d -o recovery-key.txt recovery-key.txt.age
```

## Access secrets

To decrypt a secret:

```bash
SOPS_AGE_KEY_FILE=./recovery-key.txt \
  sops decrypt ../secrets/secret-name.yaml
```

To edit a secret:

```bash
SOPS_AGE_KEY_FILE=./recovery-key.txt \
  sops edit ../secrets/secret-name.yaml
```

## Don't forget to Cleanup

**SHRED** and remove the unencrypted recovery key after use:

```bash
shred -u recovery-key.txt
```

**Important:**
- `rm` does not guarantee secure erasure, especially on SSDs. use `shred -u` 
- Never commit `recovery-key.txt` to Git.
- Keep `recovery-key.txt.age` and its passphrase safe.


