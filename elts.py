from lxml import etree
from copy import deepcopy
import os
import click

ELTS = [
  {
    "name": "Applications of Functions",
    "sections": [(1,1),(1,2),(1,3)],
  },
  {
    "name": "Linear and Quadratic Functions",
    "sections": [(1,4),(1,5)],
  },
  {
    "name": "Manipulating Functions",
    "sections": [(1,6),(1,7),(1,8),(1,9)],
  },
  {
    "name": "Analyzing the circle",
    "sections": [(2,1),(2,2)],
  },
  {
    "name": "Sine and Cosine",
    "sections": [(2,3),(2,2)],
  },
  {
    "name": "Exponential Functions",
    "sections": [(3,1),(3,2),(3,3)],
  },
  {
    "name": "Logarithmic Functions",
    "sections": [(3,4),(3,5),(3,6)],
  },
  {
    "name": "Right Triangles and Tangent",
    "sections": [(4,1),(4,2)],
  },
  {
    "name": "Angles and Trigonometry",
    "sections": [(4,3),(4,4),(4,5)],
  },
  {
    "name": "Limits and Polynomials",
    "sections": [(5,1),(5,2),(5,3)],
  },
  {
    "name": "Rational Functions",
    "sections": [(5,4),(5,5)],
  },
]

#def create_dir(path):
#  if not os.path.exists(path):
#    os.makedirs(path)

#@click.group()
#def cli():
#    pass

#@click.command()
#def list_section_ids():
#  book = etree.parse("apc/src/index.xml")
#  book.xinclude()
#  for cindex, chapter in enumerate(book.xpath("//chapter"), start=1):
#    for sindex, section in enumerate(chapter.xpath("section"), start=1):
#      section_code = str(cindex)+"."+str(sindex)
#      print(section_code+" "+section.xpath("@xml:id")[0])

@click.command()
def build():
  book = etree.parse("apc/src/index.xml")
  xsl = etree.parse("elts.xml")
  transform = etree.XSLT(xsl)
  book.xinclude()
  elt = etree.Element("elt")
  for section_tuple in ELTS[2]["sections"]:
    chapter=book.xpath("//chapter")[section_tuple[0]-1]
    section=chapter.xpath(".//section")[section_tuple[1]-1]
    elt.append(deepcopy(section))
  transform(elt,section="'bar'",includepreviews="'yes'").write_output('bar.ipynb')

#cli.add_command(build)
#cli.add_command(list_section_ids)

if __name__ == '__main__':
  #cli()
  build()