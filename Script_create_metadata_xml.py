import nltk, re
from nltk.corpus import gutenberg

for book in gutenberg.fileids():

    # get info about book
    author, title = book.split("-")
    raw = gutenberg.raw(book)

    # create XML text
    output_xml = '<?xml version="1.0" encoding="UTF-8"?>\n'
    output_xml += f'<text author = "{author.title()}" title = "{title.title()}">\n'
    output_xml += raw + "\n"
    output_xml += "</text>"
    
    # write out to XML file
    outfilename = re.sub(r"\.txt$", ".xml", title)
    with open(f"/pathway/to/{outfilename}", mode = "w", encoding = "utf8") as outfile:
        outfile.write(output_xml)