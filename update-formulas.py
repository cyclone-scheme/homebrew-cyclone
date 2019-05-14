#!/usr/bin/env python

import sys
import os
import shutil
import time
import sys
import hashlib
import tempfile
import shutil
from io import StringIO
from pathlib import Path

import requests
import sh
from git import Repo
from git_pull_request import git_pull_request

HOMEBREW_CYCLONE_PROJECT_URL = "git@github.com:adamfeuer/homebrew-cyclone.git"

CYCLONE = "cyclone"
CYCLONE_PROJECT_URL = f"https://github.com/justinethier/{CYCLONE}"
CYCLONE_GIT_REPO_URL = f"{CYCLONE_PROJECT_URL}.git"
CYCLONE_RELEASES_URL = f"{CYCLONE_PROJECT_URL}/archive"

CYCLONE_BOOTSTRAP = "cyclone-bootstrap"
CYCLONE_BOOTSTRAP_PROJECT_URL = f"https://github.com/justinethier/{CYCLONE_BOOTSTRAP}"
CYCLONE_BOOTSTRAP_RELEASES_URL = f"{CYCLONE_BOOTSTRAP_PROJECT_URL}/archive"
CYCLONE_BOOTSTRAP_GIT_REPO_URL = f"{CYCLONE_BOOTSTRAP_PROJECT_URL}.git"

projects = (
                { 
                    "name": CYCLONE,
                    "description": ":cyclone: A brand-new compiler that allows practical application development using R7RS Scheme.",
                    "classname": "Cyclone",
                    "formula_file_name": "cyclone.rb",
                    "project_url": CYCLONE_PROJECT_URL,
                    "releases_url": CYCLONE_RELEASES_URL,
                    "git_repo_url": CYCLONE_GIT_REPO_URL,
                },
                { 
                    "name": CYCLONE_BOOTSTRAP,
                    "description": ":cyclone-bootstrap: R7RS Scheme compiler used to bootstrap the cyclone R7RS Scheme compiler",
                    "classname": "CycloneBootstrap",
                    "formula_file_name": "cyclone-bootstrap.rb",
                    "project_url": CYCLONE_BOOTSTRAP_PROJECT_URL,
                    "releases_url": CYCLONE_BOOTSTRAP_RELEASES_URL,
                    "git_repo_url": CYCLONE_BOOTSTRAP_GIT_REPO_URL,
                },
          )


CLASSNAME = "@@CLASSNAME@@"
DESCRIPTION = "@@DESCRIPTION@@"
ARCHIVE_URL = "@@ARCHIVE_URL@@"
ARCHIVE_SHA = "@@ARCHIVE_SHA@@"
ARCHIVE_VERSION = "@@ARCHIVE_VERSION@@"

BUF_SIZE = 65536  



def get_sha256(fileobj):
    sha256_hash = hashlib.sha256()
    for byte_block in iter(lambda: fileobj.read(4096),b""):
        sha256_hash.update(byte_block)
    return sha256_hash.hexdigest()


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


def get_sha256_for_url(url):
    with requests.get(url, stream=True) as r:
        r.raise_for_status()
        with tempfile.NamedTemporaryFile() as f:
            for chunk in r.iter_content(chunk_size=8192):
                if chunk: # filter out keep-alive new chunks
                    f.write(chunk)
                    # f.flush()
            f.seek(0)
            sha256 = get_sha256(f) 
    return sha256


def should_update(formula_file_name, archive_version):
    with open(formula_file_name, "r") as formula_file:
        contents = formula_file.read()
    formula_version = ""
    for line in contents.split('\n'):
        words = line.strip().split()
        if len(words) > 1 and words[0] == "version":
            formula_version = words[1].strip('"')
    return archive_version != formula_version 


def get_templates():
    with open("cyclone-formula.rb.template") as template:
        contents = template.read()
    updated = []
    version = "NO_VERSION"
    for project in projects:
        if os.path.exists(project["name"]):
            shutil.rmtree(project["name"])
        sh.git("clone", project["git_repo_url"])
        formula_file_name = project["formula_file_name"]
        archive_version = get_most_recent_tag(project["name"])
        version = archive_version
        print(f'The latest tag in repo {project["name"]} is {archive_version}.') 
        shutil.rmtree(project["name"])
        sh.git("clone", project["git_repo_url"])
        if should_update(formula_file_name, archive_version):
            updated.append(formula_file_name)
            print(f"Updating formula {formula_file_name} to {archive_version}.")
            if should_update(formula_file_name, archive_version):
                archive_url = "{}/{}.tar.gz".format(project["releases_url"], archive_version)
                archive_sha = get_sha256_for_url(archive_url)
                new_contents = contents.replace(CLASSNAME, project["classname"])
                new_contents = new_contents.replace(DESCRIPTION, project["description"])
                new_contents = new_contents.replace(ARCHIVE_URL, archive_url)
                new_contents = new_contents.replace(ARCHIVE_SHA, archive_sha)
                new_contents = new_contents.replace(ARCHIVE_VERSION, archive_version)
                with open(formula_file_name, "w") as formula_file:
                    formula_file.write(new_contents)
    if updated:
        branch_name = "update_formulas_to_version_{}".format(version).replace('.', '_')
        sh.git("checkout", "-b", branch_name)
        for formula_file_name in updated:
            sh.git("add", formula_file_name)
        title = "update homebrew formulas to version {}".format(version) 
        message = f"{title}\n\n{title}\nThis pull request was created automatically by a script." 
        sh.git("commit", "-m", title) 
        sh.git("push", "--set-upstream", "origin", branch_name)  
        #sh.hub("pull-request", "-m", message)
        print(f"Created pull request for branch {branch_name}.")
    else:
        print("No formulas need updating.")



def main():
    get_templates()


if __name__ == "__main__":
    main()

