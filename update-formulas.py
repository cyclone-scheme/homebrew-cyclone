#!/usr/bin/env python

import sys
import os
import time
from io import StringIO

import sh
from git import Repo

CYCLONE = "cyclone"
CYCLONE_BOOTSTRAP = "cyclone-bootstrap"

CYCLONE_GIT_REPO_URL = f"https://github.com/justinethier/{CYCLONE}.git"
CYCLONE_BOOTSTRAP_GIT_REPO_URL = f"https://github.com/justinethier/{CYCLONE_BOOTSTRAP}.git"


def get_most_recent_tag(dirpath):
    repo = Repo(dirpath)
    tags = {}
    for tag_reference in repo.tags:
        text_tag = str(tag_reference.tag.tag)
        extra = ''
        if text_tag.find('-') > 0:
            text_tag, extra = text_tag.split('-', 1)
        tag_tuple= tuple([int(field) for field in text_tag[1:].split('.')])
        tags[tag_tuple] = text_tag+extra
    sorted_tags = sorted(tags.keys())
    most_recent_tag = tags[sorted_tags[-1]]
    return most_recent_tag


def main():
    sh.git("clone", CYCLONE_GIT_REPO_URL)
    sh.git("clone", CYCLONE_BOOTSTRAP_GIT_REPO_URL)
    cyclone_most_recent_tag = get_most_recent_tag("cyclone")
    print(cyclone_most_recent_tag)
    cyclone_bootstrap_most_recent_tag = get_most_recent_tag("cyclone-bootstrap")
    print(cyclone_bootstrap_most_recent_tag)


if __name__ == "__main__":
    main()

