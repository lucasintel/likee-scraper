# Likeer

![Unit Tests](https://github.com/kandayo/likee-scraper/workflows/Unit%20Tests/badge.svg)
![Integration Tests](https://github.com/kandayo/likee-scraper/workflows/Integration%20Tests/badge.svg)
[![GitHub release](https://img.shields.io/github/release/kandayo/likee-scraper.svg?label=Release)](https://github.com/kandayo/likee-scraper/releases)

Download videos **without watermark** from Likee.

**Work in progress, but decently usable.**

See also: [**Likee.cr - Unofficial Likee API wrapper for Crystal**](https://github.com/kandayo/likee.cr).

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

For more examples, please refer to the [**documentation**](https://kandayo.github.io/likee-scraper/Likeer.html).

```bash
# Archive the user feed, but stop when encountering the first already-downloaded post.
# Note: this is the default behaviour.
likeer store --fast-update <USER>

# Archive the last 5 posts of <USER>.
likeer store -n 5 <USER>
```

## Contributing

1. Fork it (<https://github.com/kandayo/likee-scraper/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [kandayo](https://github.com/kandayo) - creator and maintainer
