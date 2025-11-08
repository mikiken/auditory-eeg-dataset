# auditory-eeg-dataset
Repository to download and preprocess [SparrKULee](https://rdr.kuleuven.be/dataset.xhtml?persistentId=doi:10.48804/K3VSND) dataset.

This repository is forked from [exporl/auditory-eeg-dataset](https://github.com/exporl/auditory-eeg-dataset).

## Prerequisites
You'll need to install Nix and enable flakes. When installing, it's convenient to use the following repository: [DeterminateSystems/nix-installer](https://github.com/DeterminateSystems/nix-installer)


You can install Nix with the following command.

```bash
curl -fsSL https://install.determinate.systems/nix | sh -s -- install --determinate
```

## Usage
Enter the following command to enter the development environment.

```bash
nix develop
```

### Download dataset

```bash
mkdir -p downloads
python download_code/download_script.py downloads
```

You can specify the range of the dataset to download by setting the following options.

> `--subset {full,preprocessed,stimuli}`
> Download only a subset of the dataset. "full" downloads the full dataset, "preprocessed" downloads only the preprocessed data and "stimuli" downloads only the stimuli files. Default: full

### Preprocess
Modify the contents of [`config.json`](./config.json) in advance according to your environment.

```bash
python preprocessing_code/sparrKULee.py
```

## Links
- README (Original) : [docs/README.md](./docs/README.md)
- Dataset : https://rdr.kuleuven.be/dataset.xhtml?persistentId=doi:10.48804/K3VSND
- Paper : https://www.mdpi.com/2306-5729/9/8/94
