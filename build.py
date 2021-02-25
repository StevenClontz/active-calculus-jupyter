from lxml import etree
import os
from shutil import copytree
import click
import json

def make_directory(path):
    if not os.path.exists(path):
        os.makedirs(path)

def jupyter_dict(sources):
    # inject styling
    sources[0] = r"""
        <style>
            .editable{margin:1em;color:#ccc;font-size:2em;text-align:center;}
            .not-editable{background-color:#eefff8;padding:1em;border-radius:10px;box-shadow:4px 4px 3px #ddd;margin:5px;}
            .sidebyside{display:flex;justify-content:center;}
            .sidebyside > *{margin-right:1em;flex:1;}
            caption{caption-side:top;white-space: nowrap;color:rgba(0,0,0,.45)}}
            figcaption{padding-top:0.75em;padding-bottom:0.3em;color:rgba(0,0,0,.45)}
            .fillin{display:inline-block;width:10em;margin-left:0.2em;margin-right:0.2em;height:1em;border-bottom:1px black solid;}
            .fn{font-size:0.8em;color:rgba(0,0,0.45)}
            .newcommands{display:none;}
            tt{background-color:#f8f8f8;border:1px #888 solid;border-radius:2px;padding-left:0.2em;padding-right:0.2em;}
        </style>
    """ + sources[0]
    return {
        "cells": [jupyter_cell_dict(s) for s in sources],
        "nbformat": 4,
        "nbformat_minor": 4
    }
def jupyter_cell_dict(source):
    clean_source = " ".join(source.split())
    return {
        "cell_type": "markdown",
        "metadata": {"collapsed": False, "editable": False},
        "source": [f'<div class="not-editable">{clean_source}</div>']
    }
def header_cell_source(chapterid,sectionid,title,slug):
    result = f"<h1>{chapterid}.{sectionid} {title}</h1>"
    return result



@click.command()
def build():
    book = etree.parse("apc/src/index.xml")
    book.xinclude()
    transform = etree.XSLT(etree.parse("element-to-html.xsl"))
    make_directory("activities")
    make_directory("activities/team")
    make_directory("activities/individual")
    for chapterid, chapter in enumerate(book.xpath("//chapter"), start=1):
        for sectionid, section in enumerate(chapter.xpath("section"), start=1):
            slug = section.xpath('./@xml:id')[0]
            title = section.findtext('./title')
            file_path = f"activities/team/team-{chapterid:02}-{sectionid:02}-{slug}"
            t = transform(book,target=book.getpath(section))
            sources = [str(etree.tostring(t), encoding="UTF-8")]
#            for activity in section.xpath("subsection/activity"):
#                sources.append("<h3>ACTIVITY</h3>")
            data = jupyter_dict(sources)
            for ext in ['json','ipynb']:
                with open(f'{file_path}.{ext}', 'w', encoding='utf-8') as f:
                    json.dump(data, f, ensure_ascii=False, indent=4)
    if not os.path.exists("activities/team/images"):
        copytree("apc/src/images","activities/team/images")
    if not os.path.exists("activities/individual/images"):
        copytree("apc/src/images","activities/individual/images")

if __name__ == '__main__':
    build()