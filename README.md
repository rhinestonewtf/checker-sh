# checker.sh

Simple shell scripts for various automated checks. Currently the scripts include:

- `attestations.sh`: which loops over all networks in `networks.txt` and modules in `modules.txt` to ensure the Rhinestone Attester has attested to these modules
- `balance.sh`: checks the Rhinestone deployer balance across all chains

## Usage

1. Add a `.env` file based on `.env.example`
2. Run `source .env` to set the env variables (note that the `export` command in the env is required so the env variables should be `export ENV=ENV_VALUE`)
3. Run `chmod +x ./attestations.sh` or for the relevant script
4. Run `./attestations.sh` or for the relevant script

## Attestations

When running the attestations script, it will be run against all networks in `networks.txt` and all modules in `modules.txt`. If you want to run it only against a subset of either, then supply that subset with the `-n` flag for networks and the `-m` flag for modules. Example:

```sh
./attestations.sh -n OdysseyTestnet -m Webauthn
```

## Balance

When running the balance script it will be run against all networks in the `networks.txt` file. You can specify a subset of networks in list format. Example:

```sh
./balance.sh EthereumSepolia Base
```
