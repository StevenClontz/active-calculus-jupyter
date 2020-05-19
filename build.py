from lxml import etree
import os

if not os.path.exists('build'):
  os.makedirs('build')

book = etree.parse("apc/src/index.xml")
xsl = etree.parse("ac-to-jupyter.xml")
transform = etree.XSLT(xsl)
book.xinclude()
for cindex, chapter in enumerate(book.xpath("//chapter"), start=1):
  chapter_path = 'build/chapter-'+str(cindex)
  print(chapter_path)
  print(chapter.xpath("title")[0].text)
  if not os.path.exists(chapter_path):
    os.makedirs(chapter_path)
  for sindex, section in enumerate(chapter.xpath("section"), start=1):
    section_path = chapter_path+"/section-"+str(cindex)+"-"+str(sindex)+"-"+section.xpath('./@xml:id')[0]+".ipynb"
    print(section_path)
    print(section.xpath("title")[0].text)
    section_code = str(cindex)+"."+str(sindex)
    transform(section, section=section_code).write_output(section_path)












