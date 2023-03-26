# Customized fontconfig configuration

## Google Noto CJK fonts

`conf.avail/*-google-note-*` are copied from Fedora 37, it's better than
https://salsa.debian.org/fonts-team/fonts-noto-cjk/-/blob/e7551a12dbb68e91cfbf9c542e25dd2c5ac524b0/debian/70-fonts-noto-cjk.conf

The Debian version can select correct language-specific variant from multilingual fonts in non-CJK locale, such as:

```sh
$ LC_ALL=en_US.UTF-8 fc-match sans:lang=ko
NotoSansCJK-Regular.ttc: "Noto Sans CJK KR" "Regular"
```

But can't select correct variant in CJK locale, such as:

```sh
$ LC_ALL=zh_CN.UTF-8 fc-match sans:lang=ko      # Debian will wrongly select `Noto Sans CJK SC`
NotoSansCJK-Regular.ttc: "Noto Sans CJK KR" "Regular"
```

Notice there are two fonts for each language-specific variant, such as:

1. `Noto Sans KR`: region-specific font
2. `Noto Sans CJK KR`: multilingual font
