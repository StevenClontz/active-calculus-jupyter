from lxml import etree
import os
from shutil import copytree
import click
import json

TRANSFORM = etree.XSLT(etree.parse("element-to-html.xsl"))
PRETEXT = etree.parse("apc/src/index.xml")
PRETEXT.xinclude()

def make_directory(path):
    if not os.path.exists(path):
        os.makedirs(path)

def jupyter_dict(sources,team=True):
    # inject styling
    sources[0] = r"""
        <style>
            .not-editable{padding:1em;border-radius:10px;box-shadow:4px 4px 3px #ddd;margin:5px;}
            .not-editable.individual{background-color:#eefff8;}
            .not-editable.team{background-color:#eef8ff;}
            .sidebyside{display:flex;justify-content:center;}
            .sidebyside > *{margin-right:1em;flex:1;}
            caption{caption-side:top;white-space: nowrap;color:rgba(0,0,0,.45)}}
            figcaption{padding-top:0.75em;padding-bottom:0.3em;color:rgba(0,0,0,.45)}
            .fillin{display:inline-block;width:10em;margin-left:0.2em;margin-right:0.2em;height:1em;border-bottom:1px black solid;}
            .fn{font-size:0.8em;color:rgba(0,0,0.45)}
            .newcommands{display:none;}
            tt{background-color:#f8f8f8;border:1px #888 solid;border-radius:2px;padding-left:0.2em;padding-right:0.2em;}
            img{background-color:#fff;}
        </style>
    """ + sources[0]
    return {
        "cells": [jupyter_cell_dict(s,team=team) for s in sources],
        "nbformat": 4,
        "nbformat_minor": 4
    }
def jupyter_cell_dict(source,team=True):
    if team:
        div_class = "team"
    else:
        div_class = "individual"
    clean_source = " ".join(source.split())
    return {
        "cell_type": "markdown",
        "metadata": {"collapsed": False, "editable": False},
        "source": [f'<div class="not-editable {div_class}">{clean_source}</div>']
    }
def element_to_string(element,team=True):
    if team:
        notebook="'Team Notebook'"
    else:
        notebook="'Individual Notebook'"
    t = TRANSFORM(PRETEXT,target=PRETEXT.getpath(element),notebook=notebook)
    return str(etree.tostring(t), encoding="UTF-8")


@click.command()
def build():
    make_directory("activities")
    make_directory("activities/team")
    make_directory("activities/individual")
    for chapterid, chapter in enumerate(PRETEXT.xpath("//chapter"), start=1):
        for sectionid, section in enumerate(chapter.xpath("section"), start=1):
            slug = section.xpath('./@xml:id')[0]
            title = section.findtext('./title')
            # build team notebook
            file_path = f"activities/team/team-{chapterid:02}-{sectionid:02}-{slug}"
            sources = [element_to_string(section)]
            for activity in section.xpath(".//activity"):
                sources.append(element_to_string(activity))
                for intro in activity.xpath("statement"):
                    for element in intro.xpath("*"):
                        tasks = element.xpath("ol")
                        if len(tasks) > 0:
                            for task in tasks[0].xpath("li"):
                                sources.append(element_to_string(task))
                        else:
                            sources.append(element_to_string(element))
            data = jupyter_dict(sources)
            for ext in ['ipynb']:
                with open(f'{file_path}.{ext}', 'w', encoding='utf-8') as f:
                    json.dump(data, f, ensure_ascii=False, indent=4)
            # build individual notebook
            file_path = f"activities/individual/individual-{chapterid:02}-{sectionid:02}-{slug}"
            sources = [element_to_string(section,team=False)]
            for activity in section.xpath(".//exploration"):
                sources.append(element_to_string(activity,team=False))
                for intro in activity.xpath("statement"):
                    for element in intro.xpath("*"):
                        tasks = element.xpath("ol")
                        if len(tasks) > 0:
                            for task in tasks[0].xpath("li"):
                                sources.append(element_to_string(task,team=False))
                        else:
                            sources.append(element_to_string(element,team=False))
            data = jupyter_dict(sources,team=False)
            for ext in ['ipynb']:
                with open(f'{file_path}.{ext}', 'w', encoding='utf-8') as f:
                    json.dump(data, f, ensure_ascii=False, indent=4)
    if not os.path.exists("activities/team/images"):
        copytree("apc/src/images","activities/team/images")
    if not os.path.exists("activities/individual/images"):
        copytree("apc/src/images","activities/individual/images")

if __name__ == '__main__':
    build()