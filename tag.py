#!/usr/bin/env python

import sys

tags = {}
for line in sys.stdin.readlines():
    text_tag = line.strip()
    extra = ''
    if text_tag.find('-') > 0:
        print(text_tag)
        text_tag, extra = text_tag.split('-', 1)
    tag = tuple([int(field) for field in text_tag[1:].split('.')])
    tags[tag] = text_tag+extra
for tag in sorted(tags.keys()):
    print(tag, tags[tag])
