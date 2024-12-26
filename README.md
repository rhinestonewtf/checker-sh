# checker.sh

Simple shell scripts for various automated checks. Currently the scripts include:

- `attestations.sh`: which loops over all networks in `networks.txt` and modules in `modules.txt` to ensure the Rhinestone Attester has attested to these modules

## Usage

1. Add a `.env` file based on `.env.example`
2. Run `source .env` to set the env variables (note that the `export` command in the env is required so the env variables should be `export ENV=ENV_VALUE`)
3. Run `chmod +x ./attestations.sh` or for the relevant script
4. Run `./attestations.sh` or for the relevant script
