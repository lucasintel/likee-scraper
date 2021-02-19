# Likee Scraper

![Unit Tests](https://github.com/kandayo/likee-scraper/workflows/Unit%20Tests/badge.svg)
![Integration Tests](https://github.com/kandayo/likee-scraper/workflows/Integration%20Tests/badge.svg)
[![GitHub release](https://img.shields.io/github/release/kandayo/likee-scraper.svg?label=Release)](https://github.com/kandayo/likee-scraper/releases)

Download videos (and their metadata) from Likee.

The videos are downloaded in their original quality, with no watermark.

See also: [**Likee API Wrapper**](https://github.com/kandayo/likee.cr).

## Index

- [Features](#features)
- [Disclaimer](#disclaimer)
- [Installation](#installation)
- [Usage](#usage)
  - [Download profile by @username](#download-profile-by-username)
  - [Download profile by ID](#download-profile-by-id)
  - [Batch file](#batch-file)
  - [Fast update](#fast-update)
- [Contributing](#contributing)
- [Contributors](#contributors)

## Features

<p align="center">
  <img src="https://user-images.githubusercontent.com/43556511/108448057-ee8f7680-7258-11eb-90bd-7f253b3d0b4f.png" alt="Terminalizer">
</p>

- Download profiles by @username.
- Download profiles by User ID.
- Built for archivists in mind: smart fast update.
- Extract metadata from entities.
- Batch file, cronjob friendly.

## Disclaimer

This app is in no way affiliated with, authorized, maintained or endorsed by
Likee or any of its affiliates or subsidiaries.

This is purely an educational proof of concept.

## Installation

### From source

1. Clone the repository:

```bash
git clone https://github.com/kandayo/likee-scraper
```

2. Compile the binary in release mode:

```bash
cd likee-scraper
shards build --release
```

3. Move the binary to your PATH or use it right away:

```bash
./bin/likeer --help
```

## Usage

For more examples, please refer to the [**documentation**](https://absolab.xyz/likee-scraper).

### Download profile by @username

Looking up a user by username requires an additional API request. It's strongly
recommended to use User IDs. Usernames must be prefixed with an `@`.

```bash
$ likeer -u @username1 -u @username2
```

### Download profile by ID

If a identifier does not have a prefix, it is assumed to be an User ID.

```bash
$ likeer -u 11111111
```

### Batch file

If `--batch-file <file.txt>` (or `-a`) is given, Likee will read *file.txt*
expecting @usernames and User IDs to download, one identifier per line.
Lines starting with "#" or empty lines are considered as comments and ignored.

Usernames must be prefixed with an `@`, e.g. `@username`.

IDs must not be prefixed with an `@`, e.g. `1111111`.

```bash
$ cat batch.txt
~> # Comment (ignored)
~> @username
~> 111111111
$ likeer -a batch.txt
```

### Fast update

If `--fast-update` (or `-f`) is given, Likeer stops when arriving at the
first already downloaded video. This flag is recommended when you use Likeer
to update your personal archive.

```bash
$ likeer -u @username -f
# => Example Username - 000003.mp4 [========================] 12.1 MB / 12.1 MB
# => Example Username - 000002.mp4; skipping
# => User @username in sync!
```

## Contributing

1. Fork it (<https://github.com/kandayo/likee-scraper/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [kandayo](https://github.com/kandayo) - creator and maintainer
